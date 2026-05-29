import 'package:flutter/material.dart';
import 'pages/main_screen.dart'; // Memanggil file dari dalam folder pages

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Doa',
      theme: ThemeData(
        fontFamily: 'Roboto', 
      ),
      home: const MainScreen(), // Buka MainScreen saat aplikasi nyala
    );
  }
}