import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final Map<String, Coordinates> _lokasiMap = {
    'DKI Jakarta': Coordinates(-6.2088, 106.8456),
    'Bogor, Jabar': Coordinates(-6.5950, 106.8166),
    'Bandung, Jabar': Coordinates(-6.9175, 107.6191),
    'Surabaya, Jatim': Coordinates(-7.2504, 112.7688),
    'Semarang, Jateng': Coordinates(-6.9932, 110.4203),
    'Yogyakarta': Coordinates(-7.7956, 110.3695),
    'Medan, Sumut': Coordinates(3.5952, 98.6722),
    'Padang, Sumbar': Coordinates(-0.9471, 100.3688),
    'Palembang, Sumsel': Coordinates(-2.9909, 104.7566),
    'Makassar, Sulsel': Coordinates(-5.1477, 119.4327),
    'Denpasar, Bali': Coordinates(-8.6705, 115.2126),
    'Jayapura, Papua': Coordinates(-2.5337, 140.7186),
    'Arab Saudi (Makkah)': Coordinates(21.4225, 39.8262),
    'Malaysia (KL)': Coordinates(3.1390, 101.6869),
    'Brunei Darussalam': Coordinates(4.9031, 114.9398),
    'Turki (Istanbul)': Coordinates(41.0082, 28.9784),
    'Jepang (Tokyo)': Coordinates(35.6762, 139.6503),
    'Inggris (London)': Coordinates(51.5074, -0.1278),
    'Amerika (New York)': Coordinates(40.7128, -74.0060),
    'Mesir (Kairo)': Coordinates(30.0444, 31.2357),
  };

  String _lokasiTerpilih = 'Bogor, Jabar';
  late Timer _timer;
  DateTime _waktuSekarang = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _waktuSekarang = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coordinates = _lokasiMap[_lokasiTerpilih]!;
    final params = CalculationMethod.singapore.getParameters();
    params.madhab = Madhab.shafi;
    final jadwalHariIni = PrayerTimes.today(coordinates, params);

    final sholatBerikutnya = jadwalHariIni.nextPrayer();
    DateTime? waktuBerikutnya = jadwalHariIni.timeForPrayer(sholatBerikutnya);
    
    String namaSholatBerikutnya = 'Selesai';
    String sisaWaktuTeks = '-- : --';

    if (waktuBerikutnya != null) {
      namaSholatBerikutnya = sholatBerikutnya.name.toUpperCase();
      if (namaSholatBerikutnya == 'FAJR') namaSholatBerikutnya = 'SUBUH';
      if (namaSholatBerikutnya == 'DHUHR') namaSholatBerikutnya = 'DZUHUR';
      if (namaSholatBerikutnya == 'ASR') namaSholatBerikutnya = 'ASHAR';
      if (namaSholatBerikutnya == 'MAGHRIB') namaSholatBerikutnya = 'MAGHRIB';
      if (namaSholatBerikutnya == 'ISHA') namaSholatBerikutnya = 'ISYA';
      if (namaSholatBerikutnya == 'SUNRISE') namaSholatBerikutnya = 'TERBIT';

      Duration selisih = waktuBerikutnya.difference(_waktuSekarang);
      int jam = selisih.inHours;
      int menit = selisih.inMinutes % 60;
      int detik = selisih.inSeconds % 60;
      // Format ala Google (01j 05m 09d)
      sisaWaktuTeks = '${jam.toString().padLeft(2, '0')}j ${menit.toString().padLeft(2, '0')}m ${detik.toString().padLeft(2, '0')}d';
    }

    String tanggalMasehi = DateFormat('EEEE, d MMMM yyyy').format(_waktuSekarang);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8), // Latar belakang abu-abu sangat terang ala Google
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER & DROPDOWN LOKASI =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jadwal',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  // Dropdown berbentuk "Pill" ala Material 3
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _lokasiTerpilih,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1B4E45)),
                        style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600),
                        onChanged: (String? nilaiBaru) {
                          setState(() {
                            _lokasiTerpilih = nilaiBaru!;
                          });
                        },
                        items: _lokasiMap.keys.map<DropdownMenuItem<String>>((String nama) {
                          return DropdownMenuItem<String>(value: nama, child: Text(nama));
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= HERO CARD (KARTU UTAMA HIJAU) =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF226054), Color(0xFF153F37)], // Gradasi hijau modern
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32), // Sudut sangat melengkung
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF1B4E45).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tanggalMasehi, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                        const Icon(Icons.mosque, color: Colors.white24, size: 40),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      namaSholatBerikutnya,
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.white70, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Menuju azan dalam $sisaWaktuTeks',
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // ================= DAFTAR JADWAL (MATERIAL CARDS) =================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildKartuJadwal('Imsak', jadwalHariIni.fajr.subtract(const Duration(minutes: 10)), sholatBerikutnya == Prayer.fajr), // Imsak numpang next prayer subuh
                  _buildKartuJadwal('Subuh', jadwalHariIni.fajr, sholatBerikutnya == Prayer.fajr),
                  _buildKartuJadwal('Terbit', jadwalHariIni.sunrise, sholatBerikutnya == Prayer.sunrise),
                  _buildKartuJadwal('Dzuhur', jadwalHariIni.dhuhr, sholatBerikutnya == Prayer.dhuhr),
                  _buildKartuJadwal('Ashar', jadwalHariIni.asr, sholatBerikutnya == Prayer.asr),
                  _buildKartuJadwal('Maghrib', jadwalHariIni.maghrib, sholatBerikutnya == Prayer.maghrib),
                  _buildKartuJadwal('Isya', jadwalHariIni.isha, sholatBerikutnya == Prayer.isha),
                  const SizedBox(height: 20), // Jarak bawah
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Fungsi pembuat Kartu Jadwal Ala Google
  Widget _buildKartuJadwal(String nama, DateTime waktu, bool isNext) {
    String jamTeks = DateFormat('HH:mm').format(waktu);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          // Jika ini adalah sholat berikutnya, warnanya jadi hijau terang
          color: isNext ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isNext ? Border.all(color: const Color(0xFF1B4E45).withOpacity(0.3), width: 2) : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isNext ? Icons.notifications_active : Icons.access_time, 
                  color: isNext ? const Color(0xFF1B4E45) : Colors.grey.shade400,
                ),
                const SizedBox(width: 16),
                Text(
                  nama,
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                    color: isNext ? const Color(0xFF1B4E45) : Colors.black87,
                  ),
                ),
              ],
            ),
            Text(
              jamTeks,
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold,
                color: isNext ? const Color(0xFF1B4E45) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}