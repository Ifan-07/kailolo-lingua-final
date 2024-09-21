import 'dart:convert';
import 'dart:io';
import 'package:dictionary/components/utils.dart';
import 'package:dictionary/about_dev.dart';
import 'package:dictionary/pages/catatan/catatan.dart';
import 'package:dictionary/pages/sejarah_kailolo.dart';
import 'package:dictionary/pages/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/word.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WordPage(),
    );
  }
}

class WordPage extends StatefulWidget {
  const WordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  late List<Word> allWords;
  late List<Word> filteredWords = [];
  bool isLoading = true;
  bool isSearchBarOpen = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  Future<void> loadWords() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}assets/KamusKailolo.json');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);
        setState(() {
          allWords =
              jsonData.map((wordJson) => Word.fromJson(wordJson)).toList();
          filteredWords = allWords;
          isLoading = false;
        });
      } else {
        final response = await http.get(
          Uri.parse(
              'https://raw.githubusercontent.com/Ifan-07/kailolo-lingua-final/main/assets/KamusKailolo.json'),
        );
        if (response.statusCode == 200) {
          final jsonString = response.body;
          final List<dynamic> jsonData = jsonDecode(jsonString);
          setState(() {
            allWords =
                jsonData.map((wordJson) => Word.fromJson(wordJson)).toList();
            filteredWords = allWords;
            isLoading = false;
          });
          await File('${directory.path}/KamusKailolo.json')
              .writeAsString(jsonString);
        } else {
          throw Exception('Gagal memuat kamus');
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Gagal memuat file JSON: $e');
    }
  }

  void searchWords(String query) {
    setState(() {
      filteredWords = allWords
          .where((word) =>
              word.ind.toLowerCase().contains(query.toLowerCase()) ||
              word.kai.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget withSearchBar() {
    return Column(
      children: [
        TextField(
          onChanged: searchWords,
          controller: searchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () {
                searchController.clear();
                searchWords('');
              },
              icon: const Icon(Icons.delete),
            ),
            labelText: 'Cari kata',
            border: const OutlineInputBorder(),
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'Loading',
                  ),
                )
              : ListView.builder(
                  itemCount: filteredWords.length,
                  itemBuilder: (context, index) {
                    final word = filteredWords[index];
                    return SelectionArea(
                      child: ListTile(
                        title: Text(
                          '${word.ind} - ${word.kai}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (word.pron.isNotEmpty)
                              Text('Pengucapan: ${word.pron.join(", ")}'),
                            if (word.kaiSyns.isNotEmpty)
                              Text(
                                  'Sinonim (Kailolo): ${word.kaiSyns.join(", ")}'),
                            if (word.indSyns.isNotEmpty)
                              Text(
                                  'Sinonim (Indonesian): ${word.indSyns.join(", ")}'),
                            if (word.sents.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Contoh kalimat:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  ...word.sents
                                      .map((sent) => Text('- ${sent ?? ""}')),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget withOutSearchBar() {
    return Column(
      children: [
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'Loading',
                  ),
                )
              : ListView.builder(
                  itemCount: filteredWords.length,
                  itemBuilder: (context, index) {
                    final word = filteredWords[index];
                    return SelectionArea(
                      child: ListTile(
                        title: Text(
                          '${word.ind} - ${word.kai}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (word.pron.isNotEmpty)
                              Text('Pengucapan: ${word.pron.join(", ")}'),
                            if (word.kaiSyns.isNotEmpty)
                              Text(
                                  'Sinonim (Kailolo): ${word.kaiSyns.join(", ")}'),
                            if (word.indSyns.isNotEmpty)
                              Text(
                                  'Sinonim (Indonesian): ${word.indSyns.join(", ")}'),
                            if (word.sents.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Contoh Kalimat:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  ...word.sents
                                      .map((sent) => Text('- ${sent ?? ""}')),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title:
            const Text('Kailolo Lingua', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearchBarOpen = !isSearchBarOpen;
              });
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.menu, color: Colors.white),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('Quiz'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notes),
              title: const Text('Catatan'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CatatanScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.add_circle_outline,
              ),
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
                Navigator.push(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutDevPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: FutureBuilder<String>(
                future: lastUpdatedLocalFile(),
                // future: lastUpdatedLocalFile(),
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
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
              ),
              title: const Text('Keluar'),
              onTap: () {
                _konfirmasiKeluar(context);
              },
            ),
          ],
        ),
      ),
      body: isSearchBarOpen
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: withSearchBar(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: withOutSearchBar(),
            ),
    );
  }
}

void _konfirmasiKeluar(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              SystemNavigator.pop();
            },
            child: const Text("Ya"),
          ),
        ],
      );
    },
  );
}
