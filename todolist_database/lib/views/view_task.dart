import 'package:flutter/material.dart';
import '../data/blocs/bloc_provider.dart';
import '../data/blocs/view_task_bloc.dart';
import '../model/task.dart';

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
    TextEditingController _noteController = new TextEditingController();

    @override
    void initState() {
        super.initState();

        _viewTaskBloc = BlocProvider.of<ViewTaskBloc>(context);
        _noteController.text = widget.task.content;
    }

    void _saveTask() async {
        widget.task.content = _noteController.text;

        _viewTaskBloc.inSaveTask.add(widget.task);
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
            appBar: AppBar(
                title: Text('Task ' + widget.task.id.toString()),
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
                child: TextField(
                    maxLines: null,
                    controller: _noteController,
                ),
            ),
        );
    }
}