import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/task.dart';
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:convert';

class History extends StatefulWidget {

  @override
  _HistoryState createState() => new _HistoryState();
}


class _HistoryState extends State<History> {

  // Future<List<ToDoItem>> fetchToDoItems(http.Client client) async {

  //   var url = "http://localhost:8080/item/get";
  //   Map<String, String> headers = {"Content-type": "application/json"};
  //   String json = '{"status": 2, "user_id": 1}';

  //   final response = await client.post(url, headers: headers, body: json);
  
  //   return parseToDo(response.body);
  // }

  // List<ToDoItem> parseToDo(String responseBody){
  //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  //   return parsed.map<ToDoItem> ((json) => ToDoItem.fromJson(json)).toList();
  // }

  

  @override
  Widget build(BuildContext context ){

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("History"),
        ),

        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),


        // body: FutureBuilder<List<ToDoItem>> (
        //   future: fetchToDoItems(http.Client()),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasError) print(snapshot.error);

        //     return snapshot.hasData ?
        //     ToDosList(todos: snapshot.data)
        //     : Center(child: CircularProgressIndicator());
        //   },
        // ),


    );
  }




}


// todolist: Helper 
// class ToDosList extends StatelessWidget {
//   final List<ToDoItem> todos;

//   ToDosList({Key key, this.todos}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: todos.length,
//       itemBuilder: (context, index) {
//         return 
//         _buildTodoItem(todos[index]);
      
//       },
//     );
//   }

//   Widget _buildTodoItem(ToDoItem todo){

//     var finish = "Unfinished";
//     var icon = Icons.cancel;
   

//     if(todo.finished_time != ""){
//       finish = "Finished";
//       icon = Icons.check_circle;
//     }
    
  
//     return Card(
//         elevation: 8.0,
//         margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//         color: todo.finished_time != "" ? Colors.blue[900] : Colors.blue,
//         child: 
//             ListTile(
//               contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               leading: Container(
//                 padding: EdgeInsets.only(right: 12.0),
//                 decoration: new BoxDecoration(
//                     border: new Border(
//                         right: new BorderSide(width: 1.0,color: Colors.white,))
//                         ),
//                 child: Icon(icon, color: Colors.white,),
//                 ),

//               title: Text(finish, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white,),),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                    Text(todo.content, style: TextStyle(color: Colors.white,)),
                   
//                 ],
//                )

//             ),

//     );
//   }
// }
