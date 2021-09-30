import 'package:flutter/material.dart';
import 'package:putzplan/Controller/Controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Putzplan',
      home: Controller(),
    );
  }
// #enddocregion build
}
