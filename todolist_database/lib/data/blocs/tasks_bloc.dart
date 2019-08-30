import 'dart:async';

import './bloc_provider.dart';
import '../database.dart';
import '../../model/task.dart';

class TasksBloc implements BlocBase {
    
    final _tasksController = StreamController<List<Task>>.broadcast();

    // I/O streams:
    StreamSink<List<Task>> get _inTasks => _tasksController.sink;
    Stream<List<Task>> get tasks => _tasksController.stream;

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
    final _confirmTaskController = StreamController<Task>.broadcast();
    StreamSink<Task> get inConfirmTask => _confirmTaskController.sink;

    TasksBloc() {
        // Retrieve all the Tasks on initialization
        getTasks();

        _confirmTaskController.stream.listen(_handleConfirmTask);
        _deleteTaskController.stream.listen(_handleDeleteTask);
        _addTaskController.stream.listen(_handleAddTask);
    }

    // All stream controllers you create should be closed within this function
    @override
    void dispose() {
        _tasksController.close();
        _addTaskController.close();
        _deleteTaskController.close();
        _confirmTaskController.close();
        _taskDeletedController.close();
    }

    void getTasks() async {

        List<Task> tasks = await DBProvider.db.getStatusTask(0);
        _inTasks.add(tasks);
    }

    void _handleAddTask(Task task) async {

        await DBProvider.db.newTask(task);
        getTasks();
    }

    void _handleConfirmTask(Task task) async {

        await DBProvider.db.updateTask(task);
        getTasks();
    }

    void _handleDeleteTask(int id) async {

        await DBProvider.db.deleteTask(id);
        _inDeleted.add(true);
        getTasks();
    }
}