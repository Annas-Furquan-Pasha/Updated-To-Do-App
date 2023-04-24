import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

import '../models/task.dart';

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'tasks_list.db'), onCreate: (db, version) {
      return db.execute('CREATE TABLE tasks_list(lId TEXT PRIMARY KEY, title TEXT)');
    },
      version: 1,
    );
  }

  static Future<sql.Database> databaseTasks() async {
    final dbpath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbpath, 'tasks.db'), onCreate: (db, version) {
      return db.execute('CREATE TABLE tasks(id TEXT PRIMARY KEY, lId TEXT, title TEXT, description TEXT, dueDate TEXT, dueTime TEXT, favorite INTEGER)');
    },
    version: 1,
    );
  }

  static Future<void> insertList (String table, Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> insert (String table, Map<String, dynamic> data) async {
    final db = await DBHelper.databaseTasks();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getTasksData(String table) async {
    final db = await DBHelper.databaseTasks();
    return db.query(table);
  }

  static Future<int> deleteList(String tableName,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await DBHelper.database();
    return db.delete(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  static Future<int> deleteTask(String tableName,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await DBHelper.databaseTasks();
    return db.delete(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  static Future<int> updateList(String table, TaskList taskList, {String? where, List<dynamic>? whereArgs}) async {
    final db = await DBHelper.database();
    return db.update(table, taskList.toMap(), where: where , whereArgs: whereArgs);
  }

  static Future<int> updateTask(String table, String lId, Task task, {String? where, List<dynamic>? whereArgs}) async {
    final db = await DBHelper.databaseTasks();
    final finalMap = {
      'id': task.id,
      'title' : task.title,
      'description': task.description,
      'dueDate': task.dueDate,
      'dueTime': task.dueTime,
      'lId' : lId,
      'favorite' : task.favorite,
    };
    return db.update(table, finalMap, where: where , whereArgs: whereArgs);
  }
}