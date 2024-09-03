import 'package:display_app/loginScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DisplayApp());
}

class DisplayApp extends StatelessWidget {
  const DisplayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}
