import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() => runApp(const TarifDefteriApp());

class TarifDefteriApp extends StatelessWidget {
  const TarifDefteriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarif Defteri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFD9480F),
      ),
      home: const HomeScreen(),
    );
  }
}
