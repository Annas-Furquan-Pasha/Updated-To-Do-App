import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import './drop_down_button.dart';
import '../provider/tasks.dart';
import '../screens/task_screen.dart';

class TaskListWidget extends StatelessWidget {

  final void Function(BuildContext c, TaskList t) alertDialog;

  const TaskListWidget( this.alertDialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Tasks>(
      builder: (ctx, tasksList, ch) => tasksList.tasks.isEmpty
          ? ch!
          : ListView.builder(
        itemCount: tasksList.tasks.length,
        itemBuilder: (_, index) => Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 8, right: 8, left: 8,),
          child: Card(
            elevation: 0,
            child: ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(TaskScreen.routeName, arguments: tasksList.tasks[index].lId);
              },
              leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.secondary,child: Text(index.toString(),style: Theme.of(context).textTheme.displaySmall,),),
              title: Text(tasksList.tasks[index].title, style: Theme.of(context).textTheme.displayLarge,),
              trailing: DropDownButtonWidget(tasksList.tasks[index], alertDialog),
            ),
          ),
        ),
      ),
      child: const Center(child:Text('No tasks yet, try to add some')),
    );
  }
}
