import 'package:flutter/material.dart';

class MasjidPage extends StatelessWidget {
  const MasjidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal & Masjid'),
        backgroundColor: const Color(0xFF1B4E45), // Warna hijau khas aplikasi kamu
      ),
      body: const Center(
        child: Text(
          'Halaman Masjid sedang dalam pembuatan',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}