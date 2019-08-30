import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/task.dart';

class DBProvider {

  // create a singleton
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  // get database
  Future<Database> get database async {

    if(_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  // initalize Database
    Future<Database> initDB() async {
    // Get the location of our app directory. This is where files for our app,
    // and only our app, are stored. Files in this directory are deleted
    // when the app is deleted.

    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'todo.db');

    return await openDatabase(path, version: 1, onOpen: (db) async {
    }, onCreate: (Database db, int version) async {

      await db.execute('''
        CREATE TABLE task(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          content TEXT,
          type INTEGER,
          create_time INTEGER,
          finished_time INTEGER,
          due_date INTEGER,
          status INTEGER DEFAULT 0
        )

      ''');
    });
  }

  // create a new task
  newTask(Task task) async {
    final db = await database;
    var res = await db.insert('task', task.toJson());

    return res;

  }

  // get all tasks
  getTasks() async {
    final db = await database;
    var res = await db.query('task', orderBy: 'create_time desc');
    List<Task> tasks = res.isNotEmpty ? res.map((task) => Task.fromJson(task)).toList() : [];

    return tasks;
    
  }

  getStatusTask(int status) async {
    final db = await database;
    var res = await db.query('task', where: 'status = ?', whereArgs: [status], orderBy: 'create_time desc');

    List<Task> tasks = res.isNotEmpty ? res.map((task) => Task.fromJson(task)).toList() : [];

    return tasks;
  }

  getType(int type) async {
    final db = await database;
    var res = await db.query('task', where: 'status = ? and type = ?', whereArgs: [0, type], orderBy: 'create_time desc');

    List<Task> tasks = res.isNotEmpty ? res.map((task) => Task.fromJson(task)).toList() : [];

    return tasks;
  }

  updateTask(Task task) async {
    final db = await database;
    var res = await db.update('task', task.toJson(), where: 'id = ?', whereArgs: [task.id]);

    return res;
  }

  deleteTask(int id) async {
    final db = await database;
    
    db.delete('task', where: 'id = ?', whereArgs: [id] );
  }

}