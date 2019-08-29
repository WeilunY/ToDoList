import 'dart:async';

import './bloc_provider.dart';
import '../../data/database.dart';
import '../../model/task.dart';

class HistoryBloc implements BlocBase {

  final _historyController = StreamController<List<Task>>.broadcast();

  StreamSink<List<Task>> get _inTasks => _historyController.sink;

  Stream<List<Task>> get tasks => _historyController.stream;

  HistoryBloc() {
    getTasks();
  }

  @override
  void dispose() {
    _historyController.close();
  }

  void getTasks() async {
    List<Task> tasks = await DBProvider.db.getTasks();
    _inTasks.add(tasks);
  }


}