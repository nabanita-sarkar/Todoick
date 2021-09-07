// import 'dart:developer';
import 'package:todoick/models/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/task.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
        join(
          await getDatabasesPath(),
          'todo.db',
        ), onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, desc TEXT)',
      );
      return await db.execute(
        'CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)',
      );
      // return db;
    }, version: 1);
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.abort)
        .then((value) => taskId = value);
    return taskId;
  }

  Future<void> updateTaskTitle(int? id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDesc(int? id, String desc) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET desc = '$desc' WHERE id = '$id'");
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query("tasks");
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          desc: taskMap[index]['desc']);
    });
  }

  Future<List<Todo>> getTodos(int? taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          taskId: todoMap[index]['taskId'],
          title: todoMap[index]['title'],
          isDone: todoMap[index]['isDone']);
    });
  }

  Future<int?> getPendingTodoCount(int taskId) async {
    int? pendingTodoCount = 0;
    Database _db = await database();
    pendingTodoCount = Sqflite.firstIntValue(await _db.rawQuery(
        "SELECT COUNT(*) FROM todo WHERE taskId = '$taskId' and isDone = 0")
      );
    return pendingTodoCount;
  }

  Future<void> updateTodoDone(int? id, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  Future<void> deleteTask(int? id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE id = '$id'");
  }
}
