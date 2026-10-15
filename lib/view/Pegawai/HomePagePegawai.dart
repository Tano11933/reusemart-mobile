import 'package:flutter/material.dart';
import '/entity/Pegawai.dart';

class HomePagePegawai extends StatelessWidget {
  final Pegawai pegawai;

  const HomePagePegawai({super.key, required this.pegawai});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Kurir'),
      ),
      body: Center(
        child: Text(
          'Selamat datang Kurir, ${pegawai.namaPegawai} (${pegawai.idJabatan})!',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}