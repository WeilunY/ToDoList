import 'package:flutter/material.dart';
import './views/myHomePage.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  var homePage = MyHomePage();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(primaryColor: Color.fromRGBO(44, 50, 65, 1.0)),
      home: homePage,
    );
  }
}


// MARK: Home page construction


