import 'dart:async';

import './bloc_provider.dart';
import '../../data/database.dart';
import '../../model/task.dart';

class ViewTaskBloc implements BlocBase {
  
    final _saveTaskController = StreamController<Task>.broadcast();
    StreamSink<Task> get inSaveTask => _saveTaskController.sink;

    final _deleteTaskController = StreamController<int>.broadcast();
    StreamSink<int> get inDeleteTask => _deleteTaskController.sink;

    // This bool StreamController will be used to ensure we don't do anything
    // else until a Task is actually deleted from the database.
    final _taskDeletedController = StreamController<bool>.broadcast();

    StreamSink<bool> get _inDeleted => _taskDeletedController.sink;
    Stream<bool> get deleted => _taskDeletedController.stream;

    ViewTaskBloc() {
        // Listen for changes to the stream, and execute a function when a change is made
        _saveTaskController.stream.listen(_handleSaveTask);
        _deleteTaskController.stream.listen(_handleDeleteTask);
    }

    @override
    void dispose() {
        _saveTaskController.close();
        _deleteTaskController.close();
        _taskDeletedController.close();
    }

    void _handleSaveTask(Task task) async {
        await DBProvider.db.updateTask(task);
    }

    void _handleDeleteTask(int id) async {
        await DBProvider.db.deleteTask(id);

        // Set this to true in order to ensure a Task is deleted
        // before doing anything else
        _inDeleted.add(true);
    }
}