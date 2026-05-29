import 'package:flutter/material.dart';
import 'doa_page.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  // DATA DOA LENGKAP
  final List<Map<String, String>> _allDoa = [
    {
      'title': 'Doa Sebelum Tidur',
      'category': 'Harian',
      'arabic': 'بِاسْمِكَ اللّٰهُمَّ أَحْيَا وَأَمُوتُ',
      'latin': 'Bismika allahumma ahya wa amut.',
      'meaning': 'Dengan nama-Mu ya Allah aku hidup dan dengan nama-Mu aku mati.'
    },
    {
      'title': 'Doa Bangun Tidur',
      'category': 'Harian',
      'arabic': 'الْحَمْدُ لِلّٰهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      'latin': 'Alhamdulillahilladzi ahyana ba\'da ma amatana wa ilaihin nusyur.',
      'meaning': 'Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami, dan kepada-Nya kami dibangkitkan.'
    },
    {
      'title': 'Doa Sebelum Makan',
      'category': 'Harian',
      'arabic': 'اللَّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ',
      'latin': 'Allahumma barik lana fima razaqtana wa qina adzaban nar.',
      'meaning': 'Ya Allah, berkahilah rezeki yang Engkau berikan kepada kami dan lindungilah kami dari siksa neraka.'
    },
    {
      'title': 'Doa Sesudah Makan',
      'category': 'Harian',
      'arabic': 'الْحَمْدُ لِلّٰهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مِنَ الْمُسْلِمِينَ',
      'latin': 'Alhamdulillahilladzi ath\'amana wa saqana wa ja\'alana minal muslimin.',
      'meaning': 'Segala puji bagi Allah yang telah memberi kami makan dan minum serta menjadikan kami termasuk orang-orang Muslim.'
    },
    {
      'title': 'Doa Masuk Masjid',
      'category': 'Sholat',
      'arabic': 'اللّٰهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      'latin': 'Allahummaf-tah li abwaba rahmatik.',
      'meaning': 'Ya Allah, bukakanlah untukku pintu-pintu rahmat-Mu.'
    },
    {
      'title': 'Doa Keluar Masjid',
      'category': 'Sholat',
      'arabic': 'اللّٰهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
      'latin': 'Allahumma inni as-aluka min fadhlik.',
      'meaning': 'Ya Allah, aku memohon kepada-Mu, karunia dari-Mu.'
    },
    {
      'title': 'Doa Untuk Orang Tua',
      'category': 'Harian',
      'arabic': 'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
      'latin': 'Rabbighfir li wali-walidayya warhamhuma kama rabbayani shaghira.',
      'meaning': 'Tuhanku, ampunilah diriku dan kedua orang tuaku, sayangilah mereka sebagaimana mereka menyayangiku di waktu aku kecil.'
    },
    {
      'title': 'Doa Kebaikan Dunia Akhirat',
      'category': 'Semua',
      'arabic': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      'latin': 'Rabbana atina fid-dunya hasanah, wa fil-akhirati hasanah, wa qina adzaban nar.',
      'meaning': 'Ya Tuhan kami, berilah kami kebaikan di dunia dan kebaikan di akhirat, dan lindungilah kami dari siksa neraka.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // LOGIKA FILTERING
    List<Map<String, String>> filteredDoa = _allDoa.where((doa) {
      bool matchCategory = _selectedCategory == 'Semua' || doa['category'] == _selectedCategory;
      bool matchSearch = doa['title']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Kumpulan Doa', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                  // Search Bar Berfungsi
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: const InputDecoration(
                        hintText: 'Cari doa harian...',
                        prefixIcon: Icon(Icons.search, color: Color(0xFF1B4E45)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Kategori Chips Berfungsi
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: ['Semua', 'Harian', 'Sholat', 'Rezeki', 'Sakit'].map((cat) {
                  bool isSel = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFF1B4E45) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(cat, style: TextStyle(color: isSel ? Colors.white : Colors.black87)),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Daftar Doa Berfungsi & Klikable
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: filteredDoa.length,
                itemBuilder: (context, index) {
                  final doa = filteredDoa[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoaDetailPage(doa: doa)),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.menu_book, color: Color(0xFF1B4E45)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(doa['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoaDetailPage extends StatelessWidget {
  final Map<String, String> doa;
  const DoaDetailPage({super.key, required this.doa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B4E45)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(doa['title']!, style: const TextStyle(color: Color(0xFF1B4E45), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // KARTU ARAB
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
              ),
              child: Text(
                doa['arabic']!,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B4E45), height: 1.8),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 24),
            
            // KARTU LATIN & ARTI
            _buildInfoCard('Latin', doa['latin']!, FontStyle.italic),
            const SizedBox(height: 16),
            _buildInfoCard('Artinya', doa['meaning']!, FontStyle.normal),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String content, FontStyle style) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF1B4E45), fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          Text(content, style: TextStyle(fontSize: 16, fontStyle: style, color: Colors.black87, height: 1.5)),
        ],
      ),
    );
  }
}