import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(PizzaOrderApp());
}

class PizzaOrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pizza Order App',
      theme: ThemeData(primarySwatch: Colors.red),
      home: HomePage(),
    );
  }
}
