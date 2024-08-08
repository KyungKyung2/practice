import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/home_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffF87060), // 이미지의 주황색 배경
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Color(0xFFFFFFFF),
          ),
        ),
        cardColor: const Color(0xFFFFFFFF), // 이미지의 하얀색 글씨
      ),
      home: const HomeScreen(),
    );
  }
}
