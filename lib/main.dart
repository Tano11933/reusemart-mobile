import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p3l_mob/theme.dart';
import 'package:p3l_mob/view/ReuseMart.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ReuseColors.primaryDark,
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ReuseColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: ReuseColors.primary,
          secondary: ReuseColors.accent,
          surface: ReuseColors.surface,
          error: ReuseColors.danger,
        ),
        scaffoldBackgroundColor: ReuseColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: ReuseColors.primary,
          foregroundColor: ReuseColors.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
      ),
      home: ReuseMart(), // <-- TANPA const!
      debugShowCheckedModeBanner: false,
    );
  }
}
