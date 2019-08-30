import 'package:flutter/material.dart';
import 'package:todolist_database/data/blocs/bloc_provider.dart';
import '../data/blocs/history_bloc.dart';
import '../model/task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';


class History extends StatefulWidget {

  @override
  _HistoryState createState() => new _HistoryState();
}


class _HistoryState extends State<History> {

  HistoryBloc _historyBloc;

  @override
  void initState() {
    
    super.initState();

    _historyBloc = BlocProvider.of<HistoryBloc>(context);
  }

  @override
  Widget build(BuildContext context ){

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("History"),
        ),

        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),

        body: StreamBuilder<List<Task>> (
          stream: _historyBloc.tasks,
          builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
            
            if(snapshot.hasData){

              if(snapshot.data.length == 0){
                return Center(child: Text("Empty History"),);
              }

              List<Task> tasks = snapshot.data;

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildTodoItem(tasks[index]);
                },

              );

            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      );
    }

    Widget _buildTodoItem(Task todo){

    const textStyle =  TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0);

    var finish = "Incomplete";
    var icon = Icons.cancel;
   

    if(todo.status == 1){
      finish = "Complete";
      icon = Icons.check_circle;
    }
    
  
    return Slidable(
      
      key: Key(todo.id.toString()),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,

      actions: <Widget>[
      IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () {
          _handleDelete(todo.id);
          Scaffold.of(context).showSnackBar(
             SnackBar(
               content: Text("${todo.content} Deleted"),
               action: SnackBarAction(
                 label: "Undo",
                 onPressed: () {_handleUndoDelete(todo); },
               ),
             )
           );
          },
        ),
      ],
      
      secondaryActions: <Widget>[
        IconSlideAction(
        caption: todo.status == 1 ? "INCOMPLETE" : "COMPLETE",
        color: todo.status == 1 ? Colors.blue : Colors.blue[900],
        icon: todo.status == 1 ? Icons.cancel : Icons.check_circle,
        onTap: () {

          if (todo.status == 1) {
            _handleINComplete(todo);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("${todo.content} marked as incomplete"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {_handleUndoINComplete(todo); },
                ),
              )
            );
          } else {
            _handleComplete(todo);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("${todo.content} marked as complete"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {_handleUndoComplete(todo); },
                ),
              )
            );

          }
          
          },
        ),
      ],

      // onDismissed: (direction) async {
      //   if(direction == DismissDirection.startToEnd) {
      //     _handleDelete(todo.id);

      //      Scaffold.of(context).showSnackBar(
      //        SnackBar(
      //          content: Text("Item Deleted"),
      //          action: SnackBarAction(
      //            label: "Undo",
      //            onPressed: () {_handleUndoDelete(todo); },
      //          ),
      //        )
      //      );
         
      //     } else {
      //       _handleINComplete(todo);

      //       Scaffold.of(context).showSnackBar(
      //        SnackBar(
      //          content: Text("Item Completed"),
      //          action: SnackBarAction(
      //            label: "Undo",
      //            onPressed: () {_handleUndoINComplete(todo); },
      //          ),)
      //      );
            
      //     }
      // },

      // background: Container(
      //   padding: EdgeInsets.only(left: 16.0),
      //   color: Colors.red[800],
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       Text("DELETE", style: textStyle,)
      //     ],
      //   )
      // ),

      // secondaryBackground: Container(
      //   padding: EdgeInsets.only(right: 16.0),
      //   color: Colors.green[800],
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     children: <Widget>[
      //       Text("INCOMPELTE", style: textStyle)
      //     ],
      //   )
      // ),

      child: 
        Card(
          elevation: 8.0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          color: todo.status == 1 ? Colors.blue[900] : Colors.blue,
          child: 
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(width: 1.0,color: Colors.white,))
                          ),
                  child: Icon(icon, color: Colors.white,),
                  ),

                title: Text(finish, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white,),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(todo.content, style: TextStyle(color: Colors.white,)),
                    
                  ],
                )
              ),
      ),

    );
  }

  var temp;

  void _handleINComplete(Task todo) async{

    todo.status = 0;

    temp = todo.finishedTime;

    todo.finishedTime = "";

    _historyBloc.inUnConfirmTask.add(todo);

  }


  void _handleUndoINComplete(Task todo) async {
      todo.status = 1;
      todo.finishedTime = temp;
     _historyBloc.inUnConfirmTask.add(todo);
  }


  void _handleDelete(int id) async {
    _historyBloc.inDeleteTask.add(id);
  }

  void _handleUndoDelete(Task todo) async {
    _historyBloc.inAddTask.add(todo);
  }

  void _handleComplete(Task todo) async{

    todo.status = 1;
    DateTime now = new DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    todo.finishedTime = formattedDate;

    _historyBloc.inUnConfirmTask.add(todo);

  }

  void _handleUndoComplete(Task todo) async {
      todo.status = 0;
      todo.finishedTime = "";
     _historyBloc.inUnConfirmTask.add(todo);
  }

  
}







