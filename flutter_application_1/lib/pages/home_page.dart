import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/masjid_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quran_page.dart';
import 'quran_detail_page.dart'; // Ini untuk membereskan error di baris 144
import 'qiblat_page.dart';       // Ini untuk membereskan error QiblatPage
import 'sholat_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variabel default sebelum data diambil
  int _lastSurahNomor = 18; 
  String _lastSurahNama = 'Surah Al-Kahf';
  int _lastAyatNomor = 1;

  @override
  void initState() {
    super.initState();
    _loadLastRead(); // Muat data saat halaman dibuka
  }

  // Fungsi untuk memanggil memori HP
  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastSurahNomor = prefs.getInt('last_surah_nomor') ?? 18;
      _lastSurahNama = prefs.getString('last_surah_nama') ?? 'Surah Al-Kahf';
      _lastAyatNomor = prefs.getInt('last_ayat_nomor') ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFF1B4E45), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.mosque, color: Colors.white, size: 20), 
                      ),
                      const SizedBox(width: 12),
                      const Text('Nawaitu.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1B4E45), letterSpacing: -0.5)),
                    ],
                  ),
                  Icon(Icons.notifications_none, color: Colors.grey.shade600, size: 28),
                ],
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Assalamualaikum,', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                      const Text('Hamba Allah', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: const DecorationImage(
                        image: NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'), // Ganti dengan asset lokal jika mau
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),

              Container(
                width: double.infinity, padding: const EdgeInsets.all(28.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF226054), Color(0xFF1B4E45)]),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.menu_book, color: Colors.white70, size: 20),
                        const SizedBox(width: 8),
                        Text('Ayat Hari Ini', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('فَإِنَّ مَعَ الْعُسْرِ يُسْرًا', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
                    const SizedBox(height: 10),
                    const Text('"Karena sesungguhnya sesudah kesulitan itu ada kemudahan."\n(QS. Al-Insyirah: 5)', style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              const Text('Menu Utama', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
             Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // 1. Al-Quran diarahkan ke QuranPage (Daftar Surah)
    _buildMenuCepat(context, Icons.auto_stories, 'Al-Quran', const QuranPage()),
    
    // 2. Kiblat diarahkan ke QiblatPage (sesuai file qiblat_page.dart kamu)
    _buildMenuCepat(context, Icons.explore, 'Kiblat', const QiblatPage()),
    
    // 3. Zakat di-null dulu jika belum ada halamannya
    _buildMenuCepat(context, Icons.volunteer_activism, 'Zakat', null),
    
    // 4. Masjid diarahkan ke MasjidPage (sesuai file masjid_page.dart kamu)
    _buildMenuCepat(context, Icons.mosque, 'Masjid', const MasjidPage()),
  ],
),
              const SizedBox(height: 30),

              const Text('Terakhir Dibaca', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
              
              // ================= KARTU TERAKHIR DIBACA DINAMIS =================
              GestureDetector(
                onTap: () async {
                  // Pergi ke halaman detail quran
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuranDetailPage(nomor: _lastSurahNomor)),
                  );
                  // Refresh data saat kembali ke halaman Home!
                  _loadLastRead();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.bookmark, color: Color(0xFF1B4E45)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_lastSurahNama, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Ayat $_lastAyatNomor', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCepat(BuildContext context, IconData icon, String title, Widget? destination) {
    return GestureDetector(
      onTap: () async {
        if (destination != null) {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
          // Refresh juga saat kembali dari halaman menu utama (siapa tau save ayat dari sini)
          _loadLastRead();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fitur $title segera hadir!'), duration: const Duration(seconds: 1)));
        }
      },
      child: Column(
        children: [
          Container(
            width: 65, height: 65,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Icon(icon, size: 30, color: const Color(0xFF1B4E45)),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }
}