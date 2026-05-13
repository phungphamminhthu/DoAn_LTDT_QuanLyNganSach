import 'package:doan_quanlychitieu/screens/main_app_screen.dart';
import 'package:doan_quanlychitieu/screens/welcom_app_expense_screen.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(
      MyApp());
}


class MyApp extends StatefulWidget {


  @override
  State<MyApp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {


  void _incrementCounter() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomAppExpenseScreen(),
    );
  }
}
