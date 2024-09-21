// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:dictionary/main.dart';
import 'dart:async';

const int MAX_QUESTIONS = 10;
const int MAX_TIME_PER_QUESTION = 60;

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: QuizSettingsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuizSettingsPage extends StatefulWidget {
  const QuizSettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuizSettingsPageState createState() => _QuizSettingsPageState();
}

class _QuizSettingsPageState extends State<QuizSettingsPage> {
  int numberOfQuestions = 5; // nilai default soal
  String username = '';
  int timePerQuestion = 5; // nilai default waktu per soal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WordPage()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Masukkan Nama Anda',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Text('Pilih jumlah soal: $numberOfQuestions'),
            Slider(
              value: numberOfQuestions.toDouble(),
              min: 1,
              max: MAX_QUESTIONS.toDouble(),
              divisions: MAX_QUESTIONS - 1,
              label: numberOfQuestions.toString(),
              onChanged: (double value) {
                setState(() {
                  numberOfQuestions = value.round();
                });
              },
            ),
            const SizedBox(height: 20),
            Text('Pilih waktu per soal: $timePerQuestion detik'),
            Slider(
              value: timePerQuestion.toDouble(),
              min: 1,
              max: MAX_TIME_PER_QUESTION.toDouble(),
              divisions: MAX_TIME_PER_QUESTION - 1,
              label: timePerQuestion.toString(),
              onChanged: (double value) {
                setState(() {
                  timePerQuestion = value.round();
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (username.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Masukkan nama Anda terlebih dahulu')),
                  );
                } else if (numberOfQuestions > MAX_QUESTIONS) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Jumlah soal maksimal adalah $MAX_QUESTIONS')),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(
                        numberOfQuestions: numberOfQuestions,
                        username: username,
                        timePerQuestion: timePerQuestion,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final int numberOfQuestions;
  final String username;
  final int timePerQuestion;
  const QuizPage({
    super.key,
    required this.numberOfQuestions,
    required this.username,
    required this.timePerQuestion,
  });

  @override
  // ignore: library_private_types_in_public_api
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Map<String, String> dictionary = {
    'Taat': 'Maai',
    'Tabrak': 'Notoi',
    'Wajah': 'Ua',
    'Wasit': 'Wasiete',
    'Abang': 'Rahan',
    'Turun': 'Kuru',
    'Atas': "Lotoha'ha",
    'Bahan': 'Manara',
    'Bagaimana': 'Ahwene',
    'Bumbu': 'Tomola',
  };

  late List<String> questions;
  late String currentQuestion;
  late String correctAnswer;
  late List<String> options;
  int score = 0;
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> incorrectAnswers = [];

  late Timer _timer;
  late int _timeLeft;

  @override
  void initState() {
    super.initState();
    initializeQuiz();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void initializeQuiz() {
    questions = dictionary.keys.toList();
    questions.shuffle();
    questions = questions.take(widget.numberOfQuestions).toList();
    setNextQuestion();
  }

  void setNextQuestion() {
    if (currentQuestionIndex < questions.length) {
      currentQuestion = questions[currentQuestionIndex];
      correctAnswer = dictionary[currentQuestion]!;
      options = generateOptions();
      startTimer();
    }
  }

  void startTimer() {
    _timeLeft = widget.timePerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer.cancel();
          timeUp();
        }
      });
    });
  }

  void timeUp() {
    checkAnswer(''); // Mengirim jawaban kosong untuk menandai jawaban salah
  }

  List<String> generateOptions() {
    List<String> allOptions = [correctAnswer];
    List<String> otherOptions =
        dictionary.values.where((value) => value != correctAnswer).toList();
    otherOptions.shuffle();
    allOptions.addAll(otherOptions.take(3));
    allOptions.shuffle();
    return allOptions;
  }

  void checkAnswer(String selectedAnswer) {
    _timer.cancel(); // Hentikan timer saat jawaban dipilih

    if (selectedAnswer == correctAnswer) {
      score++;
    } else {
      incorrectAnswers.add({
        'question': currentQuestion,
        'correctAnswer': correctAnswer,
        'userAnswer': selectedAnswer.isEmpty ? 'Waktu Habis' : selectedAnswer,
      });
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        setNextQuestion();
      });
    } else {
      navigateToScorePage();
    }
  }

  void navigateToScorePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScorePage(
          score: score,
          totalQuestions: questions.length,
          onRestart: restartQuiz,
          incorrectAnswers: incorrectAnswers,
          username: widget.username,
        ),
      ),
    );
  }

  void restartQuiz() {
    setState(() {
      score = 0;
      currentQuestionIndex = 0;
      incorrectAnswers.clear();
      initializeQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Quiz', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Waktu pengerjaan: $_timeLeft detik',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _timeLeft <= 1 ? Colors.red : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Pertanyaan ${currentQuestionIndex + 1} dari ${questions.length}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Terjemahkan: $currentQuestion',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ...options.map((option) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _timer.cancel();
                              checkAnswer(option);
                            },
                            child: Text(option),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScorePage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final VoidCallback onRestart;
  final List<Map<String, dynamic>> incorrectAnswers;
  final String username;

  const ScorePage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.onRestart,
    required this.incorrectAnswers,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skor Akhir'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$username, Skor Anda : $score / $totalQuestions',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (incorrectAnswers.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Selamat! Anda menjawab semua pertanyaan dengan benar!',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )
              else ...[
                const Text('Jawaban yang Salah:',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...incorrectAnswers.map((answer) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pertanyaan: ${answer['question']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Jawaban Anda: ${answer['userAnswer']}',
                              style: const TextStyle(color: Colors.red)),
                          Text('Jawaban Benar: ${answer['correctAnswer']}',
                              style: const TextStyle(color: Colors.green)),
                          const Divider(),
                        ],
                      ),
                    )),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QuizSettingsPage()),
                  );
                },
                child: const Text('Ulangi Quiz'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
