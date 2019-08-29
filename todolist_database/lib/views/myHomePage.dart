
import 'package:flutter/material.dart';
import './taskPage.dart';
import './profile.dart';
import './history.dart';

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
          TaskPage(),
          History(),
          Profile(),
        ],
      ),

      // navigation bar
      bottomNavigationBar: new Material(
        color: Color.fromRGBO(44, 50, 65, 1.0),
        child: TabBar(
          controller: controller,
          tabs: <Tab>[
            Tab(text: "To-Dos", icon: new Icon(Icons.list)),
            Tab(text: "History", icon: new Icon(Icons.history)),
            Tab(text: "Profile", icon: new Icon(Icons.person))
          ],
        ),
      ),
    );
  }
}