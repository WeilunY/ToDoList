import 'package:flutter/material.dart';
import 'views/todoList.dart';
import 'views/profile.dart';
import 'views/history.dart';

void main() => runApp(MyApp());

const color = Color.fromRGBO(58, 66, 86, 1.0);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(primaryColor: color),
      home: MyHomePage(),
    );
  }
}


// MARK: Home page construction
class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  TabController controller;

  // initialize tab controller
  @override
  void initState() {
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      
      // view contents
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          ToDoList(),
          History(),
          Profile(),
        ],
      ),

      // navigation bar
      bottomNavigationBar: new Material(
        color: color,
        child: TabBar(
          controller: controller,
          tabs: <Tab>[
            Tab(text: "To-Dos", icon: new Icon(Icons.home)),
            Tab(text: "History", icon: new Icon(Icons.message)),
            Tab(text: "Profile", icon: new Icon(Icons.cloud))
          ],
        ),
      ),
    );
  }
}

