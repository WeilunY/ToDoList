
import 'package:flutter/material.dart';
import '../data/blocs/home_bloc.dart';
import './taskPage.dart';
import './profile.dart';
import './history.dart';
import '../data/blocs/bloc_provider.dart';
import '../data/blocs/tasks_bloc.dart';
import '../data/blocs/history_bloc.dart';

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  BottomNavBarBloc _bottomNavBarBloc;

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {

          switch (snapshot.data) {
            
            case NavBarItem.TASK:
              return BlocProvider(
                bloc: TasksBloc(),
                child: TaskPage());

            case NavBarItem.HISTORY:
              return BlocProvider(
                bloc: HistoryBloc(),
                child: History(),
              );

            case NavBarItem.PROFILE:
              return Profile();
          }
        },
      ),

      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return BottomNavigationBar(

            backgroundColor: Color.fromRGBO(44, 50, 65, 1.0),
            fixedColor: Colors.blueAccent,
            unselectedItemColor: Colors.white,
            currentIndex: snapshot.data.index,
            onTap: _bottomNavBarBloc.pickItem,

            items: [
              BottomNavigationBarItem(
                title: Text('Todos'),
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                title: Text('History'),
                icon: Icon(Icons.notifications),
              ),
              BottomNavigationBarItem(
                title: Text('Profile'),
                icon: Icon(Icons.settings),
              ),
            ],
          );
        },
      ),
    );
  }

  // TabController controller;


  // // initialize tab controller
  // @override
  // void initState() {
  //   controller = new TabController(length: 3, vsync: this);
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return new Scaffold(

      
  //     // view contents
  //     body: TabBarView(
  //       controller: controller,
  //       children: <Widget>[
          
  //         BlocProvider(
  //           bloc: TasksBloc(),
  //           child: TaskPage(),
  //         ),
          
  //         History(),
  //         Profile(),
  //       ],
  //     ),

  //     // navigation bar
  //     bottomNavigationBar: new Material(
  //       color: Color.fromRGBO(44, 50, 65, 1.0),
  //       child: TabBar(
  //         controller: controller,
  //         tabs: <Tab>[
  //           Tab(text: "To-Dos", icon: new Icon(Icons.list)),
  //           Tab(text: "History", icon: new Icon(Icons.history)),
  //           Tab(text: "Profile", icon: new Icon(Icons.person))
  //         ],
  //       ),
  //     ),
  //   );
  // }
}