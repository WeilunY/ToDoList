import 'package:flutter/material.dart';
import '../data/blocs/bloc_provider.dart';
import '../data/blocs/tasks_bloc.dart';
import '../views/view_task.dart';
import '../data/blocs/view_task_bloc.dart';
import '../model/task.dart';
import 'package:intl/intl.dart';
import './todoForm.dart';
//import '../model/type.dart';


class TaskPage extends StatefulWidget {

  @override
  _TaskPageState createState() => _TaskPageState();

}

class _TaskPageState extends State<TaskPage> {

  TasksBloc _tasksBloc;

  @override
  void initState() {
      super.initState();

      // Thanks to the BlocProvider providing this page with the NotesBloc,
      // we can simply use this to retrieve it.
      _tasksBloc = BlocProvider.of<TasksBloc>(context);

  }

  void _addTask(Map<String, dynamic> result) async {
    String content = result['content'];
    int type = result['type'];
    int due;
    if(result['due'] != null){
      //due = DateFormat('yyyy-MM-dd').format(result['due']);
      due = result['due'].millisecondsSinceEpoch;
    }


    int now = new DateTime.now().millisecondsSinceEpoch;
    //String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    Task task = new Task(content: content, createTime: now, type: type, dueDate: due, status: 0);
    await _tasksBloc.inAddTask.add(task);

    _tasksBloc.updateType(task.type);
  }

  void _pushTodoScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TodoForm(type: type,))
    );
    
    if(result != null){
       this._addTask(result);
    }
  }

  void _navigateToView(Task task) async {

    final update = await Navigator.of(context).push(
        MaterialPageRoute( 
          builder: (context) => BlocProvider(
              bloc: ViewTaskBloc(),
              child: ViewTaskPage(
                  task: task,
              ),
          ),
        ),
    );

    if (update != null) {
        _tasksBloc.updateType(task.type);
    }
  }

  void _handleComplete(Task todo) async{

    todo.status = 1;
    int now = new DateTime.now().millisecondsSinceEpoch;
    //String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    todo.finishedTime = now;

    await _tasksBloc.inConfirmTask.add(todo);
    _tasksBloc.updateType(type);

  }

  void _handleUndoComplete(Task todo) async {
      todo.status = 0;
      todo.finishedTime = null;
     await _tasksBloc.inConfirmTask.add(todo);
     _tasksBloc.updateType(type);
  }


  void _handleDelete(int id) async {
    await _tasksBloc.inDeleteTask.add(id);
    _tasksBloc.updateType(type);
  }

  void _handleUndoDelete(Task todo) async {
    await _tasksBloc.inAddTask.add(todo);
    _tasksBloc.updateType(type);
  }

  var type = 0;
  var title = "All";

  Widget _buildType(int code, String content, Color color, Icon icon){
    return Container(
      padding: EdgeInsets.fromLTRB(12.0, 8.0, 16.0, 8.0),
      margin: EdgeInsets.only(bottom: 8.0),
      color: color,
      child: ListTile(
        leading: icon,
        title: Text( content ,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
        onTap: () async {
          _tasksBloc.updateType(code);
          setState(() {
            type = code;
            title = content;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      drawer: Drawer(

        child: Container(
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: ListView(
          // Important: Remove any padding from the ListView.
          
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 8.0),
              child: Text('Select Type', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),),
              decoration: BoxDecoration(
                color: Color.fromRGBO(44, 50, 65, 1.0),
              ),
            ),
            _buildType(0, "All", Colors.black87, Icon(Icons.present_to_all, color: Colors.white,)),
            _buildType(1, "Home", Colors.blue[800], Icon(Icons.home, color: Colors.white,)),
            _buildType(2, "School", Colors.purple[800], Icon(Icons.school, color: Colors.white,)),
            _buildType(3, "Work", Colors.indigo[800], Icon(Icons.work, color: Colors.white,),),

           
          ],
        ),
      ),),

      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),

      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<Task>>(
                stream: _tasksBloc.tasks,
                builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                  
                  if (snapshot.hasData) {

                    if (snapshot.data.length == 0) {
                        return Center(child: Text('No Tasks to do'));
                    }

                    List<Task> tasks = snapshot.data;
                    int colorCode = 1000;

                    return ListView.builder(
                      itemCount: snapshot.data.length,

                      itemBuilder: (BuildContext context, int index) {

                        // Change Colors
                        if(index < tasks.length) {

                          if(colorCode > 300){
                            colorCode -= 100;
                          } else {
                            colorCode = 300;
                          }

                        return _buildTodoItem(tasks[index], colorCode);
                        }
                      }
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              ),
            )
          ],
        )
      ),

      // Buttons: 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FloatingActionButton(
        elevation: 8.0,
        backgroundColor: Color.fromRGBO(44, 50, 65, 1.0),
        onPressed: _pushTodoScreen,
        tooltip: 'Add task',
        child: new Icon(Icons.add),),
    );
  }

  String formatDate(int timestamp) {

    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);

    int now = new DateTime.now().millisecondsSinceEpoch;
    int today_0 = now -((now + 28800000) % 86400000);
    int today_24 = today_0 + 86400000;
  
    // just now (2 mins)
    if(timestamp <= now && timestamp > now - 120000 ){
      return "just now";
    }
    // 1 hr ago
    else if (timestamp <= now - 120000 && timestamp > now - 3600000){
      return "a hour ago";
    }
    // earlier today
    else if (timestamp <= now - 3600000 && timestamp >= today_0 ){
      //return new DateFormat("h:mm a").format(date);
      return "today";
    }
    // today
    else if (timestamp > now && timestamp < today_24) {
      return "today";
    }
    else {
      return new DateFormat("yyyy-MM-dd").format(date);
    }

  }
  
  // Build Each Item: 
  Widget _buildTodoItem(Task todo, int colorCode){

    Map<int, dynamic> colors = {1: Colors.blue[colorCode], 2: Colors.purple[colorCode], 3: Colors.indigo[colorCode]};
    Map<int, dynamic> icons = {1: Icons.home, 2: Icons.school, 3: Icons.work};

    const textStyle =  TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0);
    
    return Dismissible(

      key: Key(todo.id.toString()),

      onDismissed: (direction) async {
        if(direction == DismissDirection.startToEnd) {
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
         
          } else {
            _handleComplete(todo);

            Scaffold.of(context).showSnackBar(
             SnackBar(
               content: Text("${todo.content} Completed"),
               action: SnackBarAction(
                 label: "Undo",
                 onPressed: () {_handleUndoComplete(todo); },
               ),)
           );
            
          }
      },

      background: Container(
        padding: EdgeInsets.only(left: 16.0),
        color: Colors.red[800],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("DELETE", style: textStyle,)
          ],
        )
      ),

      secondaryBackground: Container(
        padding: EdgeInsets.only(right: 16.0),
        color: Colors.green[800],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text("COMPELTE", style: textStyle)
          ],
        )
      ),

      child: Card(
        color: colors[todo.type],
        elevation: 8.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),


        child: Container(
          //decoration: BoxDecoration(),

          child: 
            ListTile(
              onTap: () => _navigateToView(todo),

              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),

              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24)
                  )
                ),

                child: Icon(icons[todo.type], color: Colors.white,),
                ),

              title: Text(todo.content ?? "", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),),

              subtitle: Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 6.0),     
                    child: Text(todo.dueDate != null ? "Due ${formatDate(todo.dueDate)}" : "No due date", 
                          style: TextStyle(color: Colors.grey[200], fontSize: 16.0),),
                  ),           
                  Text("Created ${formatDate(todo.createTime)}", 
                        style: TextStyle(color: Colors.grey[400], fontSize: 12.0),),

                ],
               ),
              ),            
            ),   
          )
        )
      );
    
    }


}