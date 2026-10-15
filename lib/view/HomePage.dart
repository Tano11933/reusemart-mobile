import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reuse Mart Home'),
        backgroundColor: const Color(0xFF173B61),
      ),
      body: const Center(
        child: Text(
          'Selamat datang di Reuse Mart!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
