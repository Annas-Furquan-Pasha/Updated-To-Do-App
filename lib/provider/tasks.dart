import 'package:flutter/material.dart';

import '../models/task.dart';
import '../helper/db_helper.dart';

class Tasks with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks {
    return [..._tasks];
  }

  Task findById(String id) {
    return _tasks.firstWhere((element) => element.id == id);
  }

  void addTask(Task task) {
    final newTask = Task(
      title: task.title,
      id: DateTime.now().toString(),
      description: task.description,
      dueDate: task.dueDate,
      dueTime: task.dueTime,
    );
    _tasks.add(newTask);
    notifyListeners();
    DBHelper.insert('tasks', {
      'id' : newTask.id,
      'title' : newTask.title,
      'description' : newTask.description,
      'dueDate' : newTask.dueDate,
      'dueTime' : newTask.dueTime,
    });
  }

  void updateTask(String id, Task task) async {
    int index = _tasks.indexWhere((element) => element.id == id);
    _tasks[index] = task;
    notifyListeners();
    await DBHelper.update('tasks', task, where: 'id = ?', whereArgs: [id]);
  }

  void deleteTask(String id) async {
    _tasks.removeWhere((element) => element.id == id);
    notifyListeners();
    await DBHelper.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> fetchAndSetTasks() async {
    final dataList = await DBHelper.getData('tasks');
    _tasks = dataList.map((item) =>
        Task(id: item['id'], title: item['title'], description: item['description'], dueDate: item['dueDate'], dueTime: item['dueTime'])).toList();
    notifyListeners();
  }
}