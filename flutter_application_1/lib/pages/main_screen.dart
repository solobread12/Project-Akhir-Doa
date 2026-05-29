import 'package:flutter/material.dart';
import 'jadwal_page.dart';
import 'home_page.dart';
import 'doa_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Default di tengah (Home)

  // Daftar halaman yang akan ditampilkan sesuai menu yang diklik
  final List<Widget> _pages = [
    const JadwalPage(),
    const HomePage(),
    const DoaPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Menampilkan halaman sesuai index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1B4E45), // Warna hijau saat aktif
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Ganti halaman saat diklik
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Jadwal'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pan_tool_alt), label: 'Doa'), 
        ],
      ),
    );
  }
}