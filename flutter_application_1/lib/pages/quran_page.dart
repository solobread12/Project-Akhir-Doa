import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'quran_detail_page.dart'; // Memanggil halaman detail yang kita buat di langkah 1

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  // Fungsi mengambil daftar 114 Surah dari API
  Future<List<dynamic>> getDaftarSurah() async {
    var response = await http.get(Uri.parse('https://equran.id/api/surat'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat daftar surah');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: AppBar(
        title: const Text('Al-Quran', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B4E45),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getDaftarSurah(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1B4E45)));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Gagal memuat data Al-Quran.'));
          }

          var listSurah = snapshot.data!;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: listSurah.length,
            itemBuilder: (context, index) {
              var surah = listSurah[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Container(
                    width: 36, height: 36,
                    decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                    child: Center(
                      child: Text(
                        '${surah['nomor']}',
                        style: const TextStyle(color: Color(0xFF1B4E45), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  title: Text(
                    surah['nama_latin'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    '${surah['tempat_turun'].toString().toUpperCase()} • ${surah['jumlah_ayat']} Ayat',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  trailing: Text(
                    surah['nama'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B4E45)),
                  ),
                  onTap: () {
                    // Ketika surah diklik, pindah ke halaman detail membawa nomor surahnya
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuranDetailPage(nomor: surah['nomor']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}