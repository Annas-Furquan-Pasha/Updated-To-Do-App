import 'package:flutter/material.dart';

import '../models/task.dart';
import '../helper/db_helper.dart';

class Tasks with ChangeNotifier {
  List<TaskList> _tasks = [];

  List<TaskList> get tasks {
    return [..._tasks];
  }

  void addTask(String lId, Task task) {
    final editTask = Task(
      lId: lId,
      id: DateTime.now().toString(),
      title: task.title,
      description: task.description,
      dueTime: task.dueTime,
      dueDate: task.dueDate,
    );
    _tasks.firstWhere((element) => element.lId == lId).tasksList!.add(editTask);
    notifyListeners();
    DBHelper.insert('tasks', {
      'id' : editTask.id,
      'lId' : lId,
      'title': editTask.title,
      'description' : editTask.description,
      'dueDate' : editTask.dueDate,
      'dueTime' : editTask.dueTime,
    });
  }

  void addList(TaskList taskList) {
    final editList = TaskList(DateTime.now().toString(), taskList.title, []);
    _tasks.add(editList);
    notifyListeners();
    DBHelper.insertList('tasks_list', {
      'lId' : editList.lId,
      'title': editList.title,
    });
  }

  TaskList findListById(String lId) {
    return _tasks.firstWhere((element) => element.lId == lId);
  }

  Task findById(String lId, String id) {
    return _tasks.firstWhere((element) => element.lId == lId).tasksList!.firstWhere((element) => element.id == id);
  }

  void deleteTask(String lId, String id) {
    final taskList = _tasks.firstWhere((element) => element.lId == lId);
    taskList.tasksList!.removeWhere((element) => element.id == id);
    notifyListeners();
    DBHelper.deleteTask('tasks', where: 'id = ?', whereArgs: [id]);
  }

  void deleteList(String lId) {
    _tasks.removeWhere((element) => element.lId == lId);
    notifyListeners();
    DBHelper.deleteTask('tasks', where: 'lId = ?', whereArgs: [lId]);
    DBHelper.deleteList('tasks_list', where: 'lId = ? ', whereArgs: [lId]);
  }

  void updateTask(String lId, String id, Task task) {
    int lIndex = _tasks.indexWhere((element) => element.lId == lId);
    int index = _tasks.firstWhere((element) => element.lId == lId).tasksList!.indexWhere((element) => element.id == id);
    _tasks[lIndex].tasksList![index] = task;
    notifyListeners();
    DBHelper.updateTask('tasks', lId, task, where: 'lId = ? and id = ?', whereArgs: [lId, id]);
  }

  void updateListName(String lId, TaskList taskList) {
    final index = _tasks.indexWhere((element) => element.lId == lId);
    _tasks[index] = taskList;
    notifyListeners();
    DBHelper.updateList('tasks_list', taskList, where: 'lId = ?', whereArgs: [lId]);
  }

  Future<void> fetchAndSetTasks() async {
    final dataList = await DBHelper.getData('tasks_list');
    final dataTask = await DBHelper.getTasksData('tasks');
    final tasks = dataTask.map((e) => Task(id: e['id'], lId: e['lId'], title: e['title'], description: e['description'], dueDate: e['dueDate'], dueTime: e['dueTime'])).toList();
    _tasks = dataList.map((e) {
      final finalList = tasks.where((element) => element.lId == e['lId']).toList();
      return TaskList(e['lId'], e['title'], finalList);
    }).toList();
  }

}