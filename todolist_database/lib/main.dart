import 'package:flutter/material.dart';
import './data/blocs/bloc_provider.dart';
import './data/blocs/tasks_bloc.dart';
import './views/myHomePage.dart';
import './views/taskPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(primaryColor: Color.fromRGBO(44, 50, 65, 1.0)),
      home: BlocProvider(
        bloc: TasksBloc(),
        child: TaskPage(),
      )
    );
  }
}



