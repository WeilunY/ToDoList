import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list_flutter/views/todoForm.dart';
import '../model/todoItem.dart';

import 'dart:convert';

class ToDoList extends StatefulWidget {

  @override
  _ToDoListState createState() => new _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {

  // MARK: Properties
  List<ToDoItem> _todoItems = [];
  int status = 0;
  int user_id = 1;

  @override
  void initState() {
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<ToDoItem> parseToDo(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<ToDoItem> ((json) => ToDoItem.fromJson(json)).toList();
  }

  void getData() async {

    var url = "http://localhost:8080/item/get";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"status": ${this.status}, "user_id": ${this.user_id}}';

    final response = await http.Client().post(url, headers: headers, body: json);

    setState(() {
      this._todoItems = ( parseToDo(response.body) ?? []);
    });



  }

  // add content to list
  void _addTodoItem(Map<String, dynamic> task) async{

   if (task.length > 0){

    var url = "http://localhost:8080/item/create";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"content": "${task['content']}", "type": ${task['type']}, "user_id": 1}';
    final response = await http.Client().post(url, headers: headers, body: json);

    this.getData();

   }
  }

  void _removeTodoItem(int id) async{

    var url = "http://localhost:8080/item/finish";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"item_id": "$id"}';
    final response = await http.Client().post(url, headers: headers, body: json);

    this.getData();

  }


  // building the list

  Widget _buildTodoList() {
    int color_code = 1000;
    return new ListView.builder(
      
      itemBuilder: (context, index) {
        if(index < _todoItems.length) {
          if(index % 2 == 0){
            if(color_code > 100){
              color_code -= 100;
            } else {
              color_code = 100;
            }
          }
            
          return _buildTodoItem(_todoItems[index], color_code);
        }
      },
    );
  }


  Widget _buildTodoItem(ToDoItem todo, int color_code){
    Map<int, dynamic> colors = {1: Colors.blue[color_code], 2: Colors.purple[color_code], 3: Colors.indigo[color_code]};
    Map<int, dynamic> icons = {1: Icons.home, 2: Icons.school, 3: Icons.business};
    
    return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),

        child: Container(
          decoration: BoxDecoration(color: colors[todo.type]),
          
          child: 
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),

              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 1.0, color: Colors.white24))
                        ),
                child: Icon(icons[todo.type], color: Colors.white,),
                ),

              title: Text(todo.content, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),),

              subtitle: Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   Text(todo.create_time, style: TextStyle(color: Colors.white),),
                   
                ],
               ),
              ),
              

              trailing: FlatButton(
                    child: Icon(Icons.check_circle, color: Colors.white),
                    onPressed:() => _promptRemoveTodoItem(todo),
                  ),

            ),
          
      )
    );
  }

  @override
  Widget build(BuildContext context ){

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("To Do List"),
        ),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        
        body: _buildTodoList(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          onPressed: _pushTodoScreen,
          tooltip: 'Add task',
          child: new Icon(Icons.add),),
    );
  }

  void _pushTodoScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TodoForm())
    );
    
    if(result != null){
       this._addTodoItem(result);
    }
  }

  void _promptRemoveTodoItem(ToDoItem todo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Mark "${todo.content}" as done?'),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('CANCEL'),
                  onPressed: () => Navigator.of(context).pop()
              ),
              new FlatButton(
                  child: new Text('MARK AS DONE'),
                  onPressed: () {
                    _removeTodoItem(todo.id);
                    Navigator.of(context).pop();
                  }
                )
             ]

          );
        }
    );
  }
}






