import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String title;

  const EmptyScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("Welcome to $title!", style: TextStyle(fontSize: 18))),
    );
  }
}
