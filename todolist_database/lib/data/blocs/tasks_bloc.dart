import 'dart:async';

import './bloc_provider.dart';
import '../database.dart';
import '../../model/task.dart';

class TasksBloc implements BlocBase {
    
    final _tasksController = StreamController<List<Task>>.broadcast();

    // Input stream. We add our Tasks to the stream using this variable.
    StreamSink<List<Task>> get _inTasks => _tasksController.sink;

    // Output stream. This one will be used within our pages to display the Tasks.
    Stream<List<Task>> get tasks => _tasksController.stream;

    // Input stream for adding new Tasks. We'll call this from our pages.
    final _addTaskController = StreamController<Task>.broadcast();
    StreamSink<Task> get inAddTask => _addTaskController.sink;

    TasksBloc() {
        // Retrieve all the Tasks on initialization
        getTasks();

        // Listens for changes to the addTaskController and calls _handleAddTask on change
        _addTaskController.stream.listen(_handleAddTask);
    }

    // All stream controllers you create should be closed within this function
    @override
    void dispose() {
        _tasksController.close();
        _addTaskController.close();
    }

    void getTasks() async {
        // Retrieve all the Tasks from the database
        List<Task> tasks = await DBProvider.db.getStatusTask(0);

        // Add all of the Tasks to the stream so we can grab them later from our pages
        _inTasks.add(tasks);
    }

    void _handleAddTask(Task task) async {
        // Create the Task in the database
        await DBProvider.db.newTask(task);

        // Retrieve all the Tasks again after one is added.
        // This allows our pages to update properly and display the
        // newly added Task.
        getTasks();
    }

    void _handleUpdateTask(Task task) async {

      await DBProvider.db.updateTask(task);

      getTasks();
    }
}