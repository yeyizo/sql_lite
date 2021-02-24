import 'package:flutter/material.dart';
import 'package:sql_lite/ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reactive Flutter',
      theme:
      ThemeData(primarySwatch: Colors.red, canvasColor: Colors.transparent),
      //Our only screen/page we have
      home: HomePage(title: 'My Todo List'),
    );
  }
}