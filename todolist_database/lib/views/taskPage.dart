import 'package:flutter/material.dart';
import '../data/blocs/bloc_provider.dart';
import '../data/blocs/tasks_bloc.dart';
import '../views/view_task.dart';
import '../data/blocs/view_task_bloc.dart';
import '../model/task.dart';
import 'package:intl/intl.dart';
import './todoForm.dart';


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

      print(_tasksBloc);
  }

  void _addTask(Map<String, dynamic> result) async {
    String content = result['content'];
    int type = result['type'];
    String due = '';
    if(result['due'] != null){
      due = DateFormat('yyyy-MM-dd').format(result['due']);
    }


    DateTime now = new DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    Task task = new Task(content: content, createTime: formattedDate, type: type, dueDate: due, status: 0);
    _tasksBloc.inAddTask.add(task);
  }

  void _pushTodoScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TodoForm())
    );
    
    if(result != null){
       this._addTask(result);
    }
  }

  void _navigateToNote(Task task) async {

    bool update = await Navigator.of(context).push(
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
        _tasksBloc.getTasks();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),

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
                  // If there are no notes (data), display this message.
                    if (snapshot.data.length == 0) {
                        return Text('No Tasks to do');
                    }

                    List<Task> tasks = snapshot.data;
                    int colorCode = 1000;

                    return ListView.builder(
                      itemCount: snapshot.data.length,

                      itemBuilder: (BuildContext context, int index) {
                        if(index < tasks.length) {
                          if(index % 2 == 0){
                            if(colorCode > 100){
                              colorCode -= 100;
                            } else {
                              colorCode = 100;
                            }
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FloatingActionButton(
        elevation: 8.0,
        backgroundColor: Color.fromRGBO(44, 50, 65, 1.0),
        onPressed: _pushTodoScreen,
        tooltip: 'Add task',
        child: new Icon(Icons.add),),
    );
  }
  
  Widget _buildTodoItem(Task todo, int colorCode){

    Map<int, dynamic> colors = {1: Colors.blue[colorCode], 2: Colors.purple[colorCode], 3: Colors.indigo[colorCode]};
    Map<int, dynamic> icons = {1: Icons.home, 2: Icons.school, 3: Icons.business};
    
    return Dismissible(
      key: Key(todo.id.toString()),
      onDismissed: (direction) {
          
  
      },
      background: Container(color: Colors.red),

      child: Card(
        color: colors[todo.type],
        elevation: 8.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),

        child: Container(
          //decoration: BoxDecoration(),

          child: 
            ListTile(
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

              title: Text(todo.content, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),),

              subtitle: Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   Text(todo.createTime, style: TextStyle(color: Colors.white),),
                   Text(todo.dueDate ?? "", style: TextStyle(color: Colors.white),),
                   
                ],
               ),
              ),
              

              trailing: 
                    FlatButton(
                      child: Icon(Icons.edit, color: Colors.white),
                      onPressed:() => _navigateToNote(todo),//_promptRemoveTodoItem(todo),
                 
              )
              
             
          ),   
        )
      ),
    );
    }


}