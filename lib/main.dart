import 'package:flutter/material.dart';
import 'package:notepad/data.dart';
import 'package:notepad/step7.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoteData(
      child: MaterialApp(
        title: 'Notepad',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const NoteNavigation(),
      ),
    );
  }
}
