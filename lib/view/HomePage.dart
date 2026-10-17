import 'package:flutter/material.dart';
import '/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReuseColors.background,
      appBar: AppBar(
        title: const Text('Reuse Mart Home'),
        backgroundColor: ReuseColors.primary,
      ),
      body: const Center(
        child: Text(
          'Selamat datang di Reuse Mart!',
          style: ReuseText.title,
        ),
      ),
    );
  }
}
