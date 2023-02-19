import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

import '../models/task.dart';

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'tasks.db'), onCreate: (db, version) {
      return db.execute('CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT ,description TEXT, dueDate TEXT, dueTime TEXT)');
    },
      version: 1,
    );
  }

  static Future<void> insert (String table, Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<int> delete(String tableName,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await DBHelper.database();
    return db.delete(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  static Future<int> update(String table, Task task, {String? where, List<dynamic>? whereArgs}) async {
    final db = await DBHelper.database();
    return db.update(table, task.toMap(), where: where , whereArgs: whereArgs);
  }

}