import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dictionary/components/utils.dart';
import 'package:dictionary/main.dart';
import 'package:dictionary/about_dev.dart';
import 'package:dictionary/pages/catatan/catatan.dart';
import 'package:dictionary/pages/sejarah_kailolo.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const QuizPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

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

  @override
  void initState() {
    super.initState();
    initializeQuiz();
  }

  void initializeQuiz() {
    questions = dictionary.keys.toList();
    questions.shuffle();
    setNextQuestion();
  }

  void setNextQuestion() {
    if (currentQuestionIndex < questions.length) {
      currentQuestion = questions[currentQuestionIndex];
      correctAnswer = dictionary[currentQuestion]!;
      options = generateOptions();
    }
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
    if (selectedAnswer == correctAnswer) {
      score++;
    } else {
      incorrectAnswers.add({
        'question': currentQuestion,
        'correctAnswer': correctAnswer,
        'userAnswer': selectedAnswer,
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
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.menu, color: Colors.white),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      endDrawer: buildDrawer(context),
      body: Center(
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
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...options.map((option) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => checkAnswer(option),
                      child: Text(option),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kailolo Lingua',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Aplikasi kamus terjemahan Indonesia - Kailolo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WordPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text('Quiz'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notes),
            title: const Text('Catatan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CatatanScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Request Kosakata'),
            onTap: () async {
              const url = 'https://forms.gle/sRAH399t2tsq6rjs9';
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                throw 'Tidak bisa dijalankan $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Sejarah Negeri Kailolo'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AboutKailoloPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Tentang Developer'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AboutDevPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: FutureBuilder<String>(
              future: lastUpdatedLocalFile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    semanticsLabel: 'Loading..',
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('Waktu Update: ${snapshot.data}');
                }
              },
            ),
            onTap: () {
              Navigator.pop(context);
            },
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

  const ScorePage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.onRestart,
    required this.incorrectAnswers,
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
                'Skor Anda: $score / $totalQuestions',
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
                    MaterialPageRoute(builder: (context) => const QuizPage()),
                  );
                },
                child: const Text('Uangi Quiz'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
