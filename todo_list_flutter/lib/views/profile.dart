import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  String countString = '';
  String localCount = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Test Storage"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                  onPressed: _incrementCounter, child: Text('Increment Counter')),
              RaisedButton(onPressed: _getCounter, child: Text('Get Counter')),
              Text(
                countString,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'result：' + localCount,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        )
    );

  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      countString = countString + " 1";
    });
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    await prefs.setInt('counter', counter);
  }

  _getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      localCount = prefs.getInt('counter').toString();
    });
  }


}