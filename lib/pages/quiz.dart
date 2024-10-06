// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:dictionary/main.dart';
import 'dart:async';

const int MAX_QUESTIONS = 296;
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
                  labelText: 'Masukkan Nama Anda!',
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
            Text('Pilih waktu pengerjaan per soal: $timePerQuestion detik'),
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
                        content: Text('Masukkan nama Anda terlebih dahulu 😊')),
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
              child: const Text('Mulai Quiz'),
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
    'Abang': 'Rahan',
    'Aku': 'Au',
    'Aman': 'Aman',
    'Ambil': 'Piri',
    'Anak': "Ana'u",
    'Angin': 'Anin',
    'Angka': 'Hiti',
    'Anjing': 'Asu',
    'Apa': 'Salo',
    'Api': 'Hau',
    'Atap': 'Ate',
    'Apotek': 'Apotek',
    'Asal': 'Asale',
    'Asli': 'Manisa',
    'Atas': "Lotoha'ha",
    'Atur': "He'he",
    'Ayah': 'Au wama u',
    'Ayo': 'Make',
    'Badan': 'Badange',
    'Bagaimana': 'Ahwene',
    'Bagus': 'Mangahinya',
    'Bahan': 'Manara',
    'Bahu': 'Halau',
    'Baik': "Ma'i",
    'Baju': 'Lapun',
    'Bakar': 'Kunu',
    'Bakti': 'Poso',
    'Balik': "hale'e",
    'Bumbu': 'Tomola',
    'Banyak': 'Repu',
    'Barang': 'Manara',
    'Baru': 'Horu',
    'Basah': 'Papota',
    'Batu': 'Hatu',
    'Bawa': 'Rawa',
    'Bayar': 'Keri',
    'Bayi': 'Aopol',
    'Belakang': 'Halemuri',
    'Beli': 'Kahe',
    'Belum': 'Tausa',
    'Berat': 'Manenu',
    'Beri': 'Repe',
    'Besar': 'Irai',
    'Bicara': 'Hoa',
    'Bidang': 'Bidang',
    'Biji': 'Hatuele',
    'Buat': 'Puna',
    'Bisu': 'Tapanono',
    'Bius': 'Bius',
    'Bobok': 'Na',
    'Bohong': 'Bohong',
    'Bola': 'Bola',
    'Bom': 'Holat',
    'Boneka': 'Boneka',
    'Bonus': 'Bonus',
    'Buah': 'Buah',
    'Buang': 'Esi',
    'Buaya': 'Huae',
    'Bubur': 'Bubur',
    'Budaya': 'Adate',
    'Buka': 'Haka',
    'Bukan': 'Taha',
    'Bukit': 'Wasi',
    'Bulan': 'hurane',
    'Bumi': 'Bumi',
    'Bunuh': 'Mate',
    'Buta': 'Takouesa',
    'Butuh': 'Butuh',
    'Cabang': 'Cabang',
    'Cepat': 'Malari',
    'Cakar': 'Cakar',
    'Calon': 'Calon',
    'Campur': 'Campur',
    'Canggih': 'Canggih',
    'Cangkir': 'Ketele',
    'Capek': 'Koa',
    'Cara': 'Cara',
    'Cerdas': 'Cerdas',
    'Celana': 'Katah',
    'Cincin': "Sapau'u",
    'Cinta': 'cintah',
    'Cium': 'Panusu',
    'Mabuk': 'Ninu',
    'Makan': 'Pamana',
    'Malam': 'Molon',
    'Malas': 'ipamalas',
    'Malu': 'Pasomi',
    'Mana': 'Wene',
    'Mandi': 'Pahoi',
    'Mangga': 'Wai-wai',
    'Manis': 'Masuma',
    'Manusia': 'Mansia',
    'Mari': 'Make',
    'Masalah': 'Jubahang',
    'Masuk': 'Nusu',
    'Mati': 'Mamatan',
    'Mayat': 'Mamata',
    'Melihat': "kou'e",
    'Memang': 'Ole',
    'Membuat': 'Puna',
    'Mencari': 'Riye',
    'Mendidih': 'Kaleku',
    'Mentah': 'Amakaele',
    'Mimpi': 'Mani',
    'Minggu': 'Ahade',
    'Minta': 'Pala',
    'Minum': 'Ninu',
    'Miring': 'Ilel',
    'Muda': 'Opai',
    'Musim': 'Huran',
    'Naik': "Ka'a",
    'Nanas': 'Nanasi',
    'Nasi': 'Hala',
    'Nisan': 'Bahesane',
    'Obat': 'Moune',
    'Ombak"': 'Omba',
    'Omong': 'Hoahuri',
    'Orang': 'Mansia',
    'Pahala': 'Amalo',
    'Pahit': 'Maita',
    'Paman': 'Momo',
    'Panas': 'Kunu',
    'Pantai': 'Meite',
    'Patah': 'Tuele',
    'Pecah': 'Hisale',
    'Pedas': 'Kakasa',
    'Pekerjaan': 'Poso',
    'Pelan': 'Maru',
    'Pelanggan': 'Langganane',
    'Pemimpin': 'Uruhuai',
    'Pena': 'Potlot',
    'Pendek': 'Apole',
    'Pendiam': 'Pamarinya"',
    'Penjara': 'Sel',
    'Penyembuhan': 'Imai,eya',
    'Pepaya': 'Papaene',
    'Perabotan': 'Manara',
    'Perasaan': "Hatua'u",
    'Perdebatan': 'Palesi',
    'Perjamuan': 'Mahaia',
    'Perkawinan': 'Kawena',
    'Perkumpulan': 'Isirutuesi',
    'Permainan': 'Ibarmaenge',
    'Permen': 'Asbon',
    'Pernah': 'Etana',
    'Pertama': 'Minyai',
    'Pertolongan': 'Bantueneke',
    'Perut': 'Tia',
    'Petani': 'Mansia wasi',
    'Petir': 'Tamelen',
    'Pintu': 'Mentanurui',
    'Pisau': 'Seite',
    'Polisi': "Mahlo'otoi",
    'Ponsel': 'Hp',
    'Posisi': "Waa'o",
    'Potong': 'Hita',
    'Potret': 'Gambare',
    'Pria': 'Malona',
    'Pukul': 'Hola',
    'Pulang': 'Reu',
    'Punya': 'Inyie"',
    'Putri': 'Mahinya',
    'Rakyat': 'Masyarakate',
    'Ramai': 'Kahua',
    'Rambut': 'Keura',
    'Ratus': 'Usael',
    'Rekan': 'Tamange',
    'Retak': 'Haitiha',
    'Ribuan': 'Usaele',
    'Ribu': 'Kahuaele',
    'Roti': 'Barotu',
    'Rumah': 'Walang',
    'Rumpu': 'Huta',
    'Runtuh': 'Roboh',
    'Rusak': 'Haipunale',
    'Sabtu': 'Sabdu',
    'Sakit': 'Masele',
    'Salam': 'Salamu',
    'Salah': 'Esalai',
    'Sama': 'Ahaisaai',
    'Sampah': 'Tetihuta',
    'Sampai': "Kawai'eya",
    'Sana': "wa'to",
    'Sapi': 'Karbou',
    'Sarung': 'Tepa',
    'Sapu': 'Salai',
    'Satu': 'Sane',
    'Sayur': 'Utane',
    'Sehat': 'Mai',
    'Sekali': 'Isai',
    'Sekarang': 'Manahti',
    'Sekolah': 'Iskola',
    'Selasa': 'Salasa',
    'Selamat': 'Salamate',
    'Selera': 'Ingmau',
    'Selimut': 'Kain Panase',
    'Seluruh': 'Louru',
    'Sembuh': 'Mai',
    'Sembunyi': 'Pakahuni',
    'Senang': 'Isanang',
    'Senin': 'Isnin',
    'Senjata': 'Bistole',
    'Serasi': 'Incocoke',
    'September': 'Saptembere',
    'Seratus': 'Utinyele',
    'Serius': 'Manisa',
    'Serta': 'Looka',
    'Setuju': 'Manisa',
    'Siang': 'Alawata',
    'Siap': 'Ole',
    'Siapa': 'Seiya',
    'Silahkan': 'Aleke',
    'Simpan': 'Pakahela',
    'Simulasi': 'balajare',
    'Sinyal': 'Jaringane',
    'Siramg': 'Kitire',
    'Sisir': 'Laria',
    'Situasi': 'Keadaane',
    'Sopan': 'mauei',
    'Spanduk': 'Baleho',
    'Subuh': 'Wairaloi',
    'Sudah': 'Pelaai',
    'Suka': 'Pasuka',
    'Suku': "he'e",
    'Sumur': 'Parigi',
    'Sungai': "wae'irai",
    'Taat': 'Maai',
    'Tabrak': 'Notoi',
    'Tadi': 'Hesoriya',
    'Tahun': 'Alawata',
    'Tahunan': 'Tahunens',
    'Tahap': 'Isapela',
    'Tajam': 'Meu',
    'Takut': 'Kele',
    'Tali': 'Walet',
    'Taman': 'Tamane',
    'Tamat': 'Tamate',
    'Tangkap': 'Kupu',
    'Tani': 'Mansia wasi',
    'Tangan': 'Rima',
    'Tanya': 'Puri',
    'Tapak': 'Lahane',
    'Tarif': 'Tarife',
    'Taruh': "He'e",
    'Tas': "Tas'e",
    'Tawas': 'Tawase',
    'Tawa': 'Maosa',
    'Tebang': 'Kotole',
    'Tebu': 'Tobu',
    'Tegak': 'Tegake',
    'Tegang': 'Alawata',
    'Tegas': 'Tegase',
    'Telah': "Pela'ai",
    'Telat': 'Manewa',
    'Telepon': 'Telepone',
    'Telinga': 'Tarinya',
    'Teluk': 'Tanjangoe',
    'Teman': 'Tamange',
    'Tempel': 'Tempele',
    'Tepat': 'Manisa',
    'Tepi': 'Talaele',
    'Terang': 'Kinag',
    'Teringat': 'Palue',
    'Terlarang': "Ehe'e",
    'Ternyata': 'Ahato',
    'Terus': 'Ioue',
    'Tiga': 'Toru',
    'Tiba': 'Ikawa',
    'Tinggi': 'Lalolo',
    'Tinggal': "Eheoi'eya",
    'Tipe': 'Ahati',
    'Tirai': 'Hordenge',
    'Tiup': 'Husale',
    'Tolak': 'Ehe',
    'Tuan': "Bos Ira'ai",
    'Tujuh': 'Itu',
    'Tumbuh': 'Akuhu',
    'Tumpang': 'Tumoange',
    'Tunda': "Ehe'ene",
    'Tunjuk': 'Patotuele',
    'Turun': 'Kuru',
    'Tusuk': 'Kiha',
    'Uang': 'Pisi',
    'Uban': 'Keura Putiele',
    'Ujung': 'Huhuele',
    'Ular': 'Nia',
    'Untuk': 'Wa',
    'Usaha': 'Poso',
    'Usai': 'Eselesaieya',
    'Usap': 'Nonaele',
    'Utang': 'Ikana',
    'Utarakan': 'Ucapiaele',
    'Utuh': 'Huale',
    'Wacana': 'Hoania',
    'Wajah': 'Ua',
    'Wajib': 'Harusei',
    'Wasit': 'Wasiete',
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
