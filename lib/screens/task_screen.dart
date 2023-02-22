import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_task_screen.dart';
import '../provider/tasks.dart';
import '../widgets/task_card.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({Key? key}) : super(key: key);

  static const routeName = '/task-screen';

  @override
  Widget build(BuildContext context) {
    final lId = ModalRoute.of(context)!.settings.arguments as String;
    final items = Provider.of<Tasks>(context).findListById(lId);
    return Scaffold(
      appBar: AppBar(
        title: Text(items.title, style: Theme.of(context).textTheme.titleLarge,),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddTaskScreen.routeName, arguments: [lId]);
              },
              icon: const Icon(Icons.add),
          )
        ],
      ),
      body: items.tasksList!.isEmpty
          ? const Center(child: Text('No tasks for the particular category'),)
          : ListView.builder(
        itemCount: items.tasksList!.length,
          itemBuilder: (ctx, index) => TaskCard(items.lId, items.tasksList![index].id, index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddTaskScreen.routeName, arguments: [lId]);
        },
        child: const Icon(Icons.add),
      ),
      );
  }
}
