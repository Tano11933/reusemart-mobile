import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p3l_mob/view/ReuseMart.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF17616E),
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReuseMart(), // <-- TANPA const!
      debugShowCheckedModeBanner: false,
    );
  }
}