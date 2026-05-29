import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuranDetailPage extends StatelessWidget {
  final int nomor;
  const QuranDetailPage({super.key, required this.nomor});

  Future<Map<String, dynamic>> getDetailSurah() async {
    var response = await http.get(Uri.parse('https://equran.id/api/surat/$nomor'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat detail Surah');
    }
  }

  // Fungsi untuk menampilkan Pop-up konfirmasi simpan ayat
  void _showSaveDialog(BuildContext context, int surahNomor, String surahNama, int ayatNomor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Simpan Penanda?', style: TextStyle(color: Color(0xFF1B4E45), fontWeight: FontWeight.bold)),
        content: Text('Tandai $surahNama Ayat $ayatNomor sebagai bacaan terakhirmu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B4E45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              // Menyimpan data ke memori HP
              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt('last_surah_nomor', surahNomor);
              await prefs.setString('last_surah_nama', surahNama);
              await prefs.setInt('last_ayat_nomor', ayatNomor);
              
              if (context.mounted) {
                Navigator.pop(context); // Tutup pop-up
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Berhasil disimpan: $surahNama Ayat $ayatNomor'),
                    backgroundColor: const Color(0xFF1B4E45),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getDetailSurah(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1B4E45)));
          }
          if (!snapshot.hasData) return const Center(child: Text('Gagal memuat data.'));

          var data = snapshot.data!;
          
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 150,
                pinned: true,
                backgroundColor: const Color(0xFF1B4E45),
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(data['nama_latin'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  centerTitle: true,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 30),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var ayat = data['ayat'][index];
                      // Menambahkan efek klik (InkWell) pada setiap ayat
                      return InkWell(
                        onTap: () {
                          _showSaveDialog(
                            context, 
                            data['nomor'], 
                            data['nama_latin'], 
                            int.tryParse(ayat['nomor'].toString()) ?? 1
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                ayat['ar'], 
                                textAlign: TextAlign.right, 
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B4E45), height: 2),
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${ayat['nomor']}. ${ayat['idn']}', 
                                style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5)
                              ),
                            ],
                          ),
                        ),
                      );
                    }, 
                    childCount: data['ayat'].length,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}