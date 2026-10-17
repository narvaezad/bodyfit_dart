
import 'package:flutter/material.dart';
import 'screens/inicio.dart';

void main() {
  runApp(const BodyFitApp());
}

class BodyFitApp extends StatelessWidget {
  const BodyFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BODYFIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090A0B),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE5FF35),
          secondary: Color(0xFFE5FF35),
          surface: Color(0xFF191A1D),
          onPrimary: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF090A0B),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF191A1D),
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white38),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE5FF35),
            ),
          ),
        ),
      ),
      home: const InicioScreen(),
    );
  }
}
