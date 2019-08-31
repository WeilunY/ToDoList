import 'package:flutter/material.dart';
import '../data/blocs/bloc_provider.dart';
import '../data/blocs/view_task_bloc.dart';
import '../model/task.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class ViewTaskPage extends StatefulWidget {
    ViewTaskPage({
        Key key,
        this.task
    }) : super(key: key);

    final Task task;

    @override
    _ViewTaskPageState createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage> {

    ViewTaskBloc _viewTaskBloc;
    //TextEditingController _noteController = new TextEditingController();

    final GlobalKey<FormBuilderState> _fbKey = new GlobalKey<FormBuilderState>();
 
    Map<int, String> types = {1: "Home", 2: "School", 3: "Work"};
    Map<int, Color> color = {1: Colors.blue[200], 2: Colors.purple[200], 3: Colors.indigo[200]};

    @override
    void initState() {
        super.initState();

        _viewTaskBloc = BlocProvider.of<ViewTaskBloc>(context);
        
    }

    void _saveTask() async {

      _fbKey.currentState.save();

       if (_fbKey.currentState.validate()) {

        Task new_task = widget.task;

        new_task.content = _fbKey.currentState.value["content"];
        if(_fbKey.currentState.value["due"] != null){
          new_task.dueDate = _fbKey.currentState.value["due"].millisecondsSinceEpoch;

        }
        
        new_task.type = _fbKey.currentState.value["type"];

        new_task.createTime = DateTime.now().millisecondsSinceEpoch;

        _viewTaskBloc.inSaveTask.add(new_task);
        print(_fbKey.currentState.value);

        Navigator.pop(context, true);
       }
    }

    void _deleteTask() {
        
        _viewTaskBloc.inDeleteTask.add(widget.task.id);

       
        _viewTaskBloc.deleted.listen((deleted) {
            if (deleted) {
                
                Navigator.of(context).pop(true);
            }
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(

            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),

            appBar: AppBar(
                title: Text('Task Detail'),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.save),
                        onPressed: _saveTask,
                    ),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: _deleteTask,
                    ),
                ],
            ),

            body: Container(
                child: ListView(
                  children: <Widget>[
                    buildFormContents(),
                  ],
                )
            ),
        );
    }

    Widget buildFormContents(){
    return FormBuilder(
      key: _fbKey,
      autovalidate: true,
     
      child: Column(
        children: <Widget>[

          Card(
            elevation: 8.0,
            color: Colors.blue[800],
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text("Enter Your Task: ", style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),),

                  FormBuilderTextField(
                    initialValue: widget.task.content,
                    attribute: "content",
                    cursorColor: Colors.white,
                    
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                    decoration: InputDecoration(isDense: false),
                   
                    validators: [
                      FormBuilderValidators.minLength(1),
                    ],
                  ),

                ],
              )
                
            )
            
          ),
          
          Card(
            elevation: 8.0,
            color: Colors.blue,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Container(
                
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text("Set a Due Date (optional): ", style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),),

                  FormBuilderDateTimePicker(
                    initialDate: widget.task.dueDate != null ? DateTime.fromMillisecondsSinceEpoch(widget.task.dueDate) : DateTime.now(),
                    attribute: "due",
                    inputType: InputType.date,
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                    format: DateFormat("yyyy-MM-dd"),
                    
                    ),
                  ]
                )
              ) 
            )
          ),

          Card(
            elevation: 8.0,
            color: color[widget.task.type == 0 ? 1 : widget.task.type],
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Container(
                
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Select Type: ", style: TextStyle(fontSize: 20.0, color: Colors.black87, fontWeight: FontWeight.bold),),

                    FormBuilderDropdown(
                      attribute: "type",
                      initialValue: widget.task.type == 0 ? 1 : widget.task.type ,
                      
                      hint: Text('Select Type'),
                      validators: [FormBuilderValidators.required()],

                      items: [1, 2, 3]
                        .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(types[type])
                      )).toList(),
                    ),
                  ]
                )
              ),
            )
          )
        ],
      ),

    );
  }
}