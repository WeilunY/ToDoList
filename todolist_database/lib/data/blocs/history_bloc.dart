import 'dart:async';

import './bloc_provider.dart';
import '../../data/database.dart';
import '../../model/task.dart';

class HistoryBloc implements BlocBase {

  final _historyController = StreamController<List<Task>>.broadcast();

  StreamSink<List<Task>> get _inTasks => _historyController.sink;

  Stream<List<Task>> get tasks => _historyController.stream;

  // add Task
  final _addTaskController = StreamController<Task>.broadcast();
  StreamSink<Task> get inAddTask => _addTaskController.sink;

// deleteTask
  final _deleteTaskController = StreamController<int>.broadcast();
  StreamSink<int> get inDeleteTask => _deleteTaskController.sink;

  final _taskDeletedController = StreamController<bool>.broadcast();

  StreamSink<bool> get _inDeleted => _taskDeletedController.sink;
  Stream<bool> get deleted => _taskDeletedController.stream;

  // confirmTask
  final _unconfirmTaskController = StreamController<Task>.broadcast();
  StreamSink<Task> get inUnConfirmTask => _unconfirmTaskController.sink;

  HistoryBloc() {
    getTasks();

    _unconfirmTaskController.stream.listen(_handleUnConfirmTask);
    _deleteTaskController.stream.listen(_handleDeleteTask);
    _addTaskController.stream.listen(_handleAddTask);

  }

  @override
  void dispose() {
    _historyController.close();
    _addTaskController.close();
    _unconfirmTaskController.close();
    _deleteTaskController.close();
    _taskDeletedController.close();
    
  }

  void getTasks() async {
    List<Task> tasks = await DBProvider.db.getTasks();
    _inTasks.add(tasks);
  }

  void _handleUnConfirmTask(Task task) async {

      await DBProvider.db.updateTask(task);
      getTasks();
  }

  void _handleDeleteTask(int id) async {

      await DBProvider.db.deleteTask(id);
      _inDeleted.add(true);
      getTasks();
  }

  void _handleAddTask(Task task) async {

        await DBProvider.db.newTask(task);
        getTasks();
  }
  


}