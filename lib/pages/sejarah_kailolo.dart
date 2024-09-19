import 'package:dictionary/components/utils.dart';
import 'package:dictionary/main.dart';
import 'package:dictionary/about_dev.dart';
import 'package:dictionary/pages/catatan/catatan.dart';
import 'package:dictionary/pages/quiz.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutKailoloPage extends StatefulWidget {
  const AboutKailoloPage({super.key});

  @override
  State<AboutKailoloPage> createState() => _AboutKailoloPageState();
}

class _AboutKailoloPageState extends State<AboutKailoloPage> {
  final List<String> imgList = [
    'assets/images/peta.png',
    'assets/images/makam.png',
    'assets/images/raja-kailolo.png',
  ];

  final List<String> captions = [
    'Peta Negeri Kailolo',
    'Makam karomah cicit Nabi Muhammad SAW dan Sunan Gresik di Negeri Kailolo',
    'Acara pengukuhan Upu Latu Sahapori (Negeri Kailolo) Bapak Ali Ohorella tahun 2023',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Sejarah Negeri Kailolo",
            style: TextStyle(color: Colors.white)),
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
                  MaterialPageRoute(builder: (context) => const QuizPage()),
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
              ),
              items: imgList.asMap().entries.map((entry) {
                int index = entry.key;
                String item = entry.value;
                return Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              captions[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            const Text(
              'Negeri Kailolo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kampung Kiai di Maluku',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: SelectionArea(
                child: Text(
                  "Maluku merupakan salah satu provinsi di bagian Timur Indonesia dengan kota Ambon sebagai pusat pemerintahan sekaligus ibu kota provinsi. Secara statistik, mayoritas orang maluku beragama Islam. Diperkirakan orang Muslim di Maluku mencapai 50,61 persen dari jumlah keseluruhan penduduk yang ada dari beberapa agama yang dianut mereka yaitu Kristen, Katolik, Hindu, Budha, Konghucu dan kepercayaan lainnya. Provinsi ini dikenal dengan sebuatan provinsi seribu pulau, karena banyaknya jumlah pulau yang kurang lebih mencapai 1.450.\n\nDari 1450-an pulau ini ada beberapa pulau yang tidak berpenghuni dan belum memiliki nama. Namun sebagian pulau yang lain telah memiliki sejarah panjang, khususnya berhubungan dengan agama Islam dan para penjajah Barat yang datang mendominasi perdagangan cengkeh pada abad ke-16 M, di antanya adalah pulau Haruku. Pulau Haruku secara administratif terletak di kecamatan Haruku Kabupaten Maluku Tengah. Di pulau ini terdapat sebelas desa, empat di antaranya berpenduduk Muslim, bahkan satu di antaranya memiliki hubungan khusus dengan Muslim Arab, itulah desa Kailolo yang dulunya merupakan salah satu bagian dari kerajaan Islam Uli Hatuhaha di kepulauan Maluku pada abad ke-14 M.\n\nDemikianlah hingga sekarang semua penduduk desa Kailolo beragama Islam. Kakek dan nenek moyang mereka telah menduduki perkampungan ini jauh sebelum kedatangan bangsa Belanda dan Portugis. Menurut cerita lisan, Islam hadir di pulau Haruku tepatnya di desa Kailolo semenjak abad ke-8 M. Islam datang dibawa langsung oleh cicit Rasulullah Ali Zainal Abidin bin Husain bin Ali bin Abi Thalib. Pendapat ini diperkuat dengan pada perwujudan 'karomah' Syekh Ali Zainal Abidin yang berupa pusara di atas bukit di Kailolo. Demikianlah Islam semakin berkembang hingga pada sekitar abad ke-12 M desa Kailolo pernah disinggahi oleh Maulana Malik Ibrahim, Sunan Gresik. Kesaksian persinggahan ini menurut kisah para penduduk dinisbatkan pada 'karomah' makam Sunan Gresik di atas bukit satu tingkat di bawah pusara Syekh Ali Zainal Abidin.\n\nSecara nasab masyarakat Islam di Kailolo memiliki hubungan dengan Ali Zainal Abidin cicit Nabi Muhammad, kebanyakan dari mereka memiliki marga al-Haddad. Meskipun dalam perkembanganya kemudian kata al-haddad disembunykan dan diganti dengan bahasa lokal yaitu marasabessy. Penggunaan kata marasabessy sebagai pengganti al-haddad ini dilakukan untuk mengelabuhi kejaran para penjajah saat itu. Menurut Bakri tokoh NU setempat yang merupakan penduduk asli Kailolo, kata marasabessy memiliki arti cahaya yang lembut atau cahaya di atas cahaya. Dalam bahasa Arab kata ini memiliki kesamaan dengan nurun alan nuur, sebuah gelar penyebutan untuk memuliakan Nabi Muhammad . Dengan menggunakan kata marasabessy ini masyarakat kailolo tetap merasa diri sangat dekat dengan Rasulullah. Pada sisi lain kata bessy juga memiliki hubungan yang sangat dekat dengan kata al-haddad.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
