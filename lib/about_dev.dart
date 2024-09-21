import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dictionary/components/utils.dart';
import 'package:dictionary/main.dart';
import 'package:dictionary/pages/catatan/catatan.dart';
import 'package:dictionary/pages/quiz.dart';
import 'package:flutter/material.dart';
import 'package:dictionary/pages/sejarah_kailolo.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDevPage extends StatefulWidget {
  const AboutDevPage({super.key});

  @override
  State<AboutDevPage> createState() => _AboutDevPageState();
}

class _AboutDevPageState extends State<AboutDevPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Tentang Developer",
          style: TextStyle(color: Colors.white),
        ),
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
                // Do nothing, already on the About Developer page
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Posisikan di tengah secara vertikal
            crossAxisAlignment: CrossAxisAlignment
                .center, // Posisikan di tengah secara horizontal
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Irfan Pattinasarany,\nIsmawaty Marasabessy,\nRisma Adinda Sakinah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Teks di tengah
              ),
              const SizedBox(height: 10),
              const Text(
                'ITB Stikom Ambon',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      "Halo, perkenalkan kami adalah Irfan, Isma, dan Risma dari kampus ITB Stikom Ambon, harapan kami aplikasi ini dapat membantu masyarakat Negeri Kailolo dalam menerjemahkan kata-kata dalam Bahasa Indonesia ke Bahasa Daerah Kailolo, begitu juga sebaliknya 😊",
                      speed: const Duration(milliseconds: 45),
                      textStyle: const TextStyle(fontSize: 15),
                      textAlign: TextAlign
                          .justify, // Untuk membuat teks rata kiri-kanan
                    )
                  ],
                  totalRepeatCount: 1,
                  displayFullTextOnTap: true,
                ),
              ),
            ],
          ),
        ),
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
