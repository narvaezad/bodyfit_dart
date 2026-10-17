import 'package:flutter/material.dart';
import 'screens/inicio.dart';
import 'screens/registro.dart';
import 'screens/resumen.dart';

void main() => runApp(const BodyFitApp());

class BodyFitApp extends StatelessWidget {
  const BodyFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BodyFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF3D3D),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D0D0D),
          centerTitle: false,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const InicioScreen(),
        '/registro': (_) => const RegistroScreen(),
        '/resumen': (_) => const ResumenScreen(),
      },
    );
  }
}
