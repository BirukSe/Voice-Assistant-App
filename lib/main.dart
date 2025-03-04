import 'package:askbura/home_page.dart';
import 'package:askbura/pallete.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AskBura',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
