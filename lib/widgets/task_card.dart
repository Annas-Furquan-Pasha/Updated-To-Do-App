import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/task_details_screen.dart';
import '../screens/add_task_screen.dart';
import '../provider/tasks.dart';

class TaskCard extends StatelessWidget {

  final String id;
  final int index;
  const TaskCard(this.id, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    final task = Provider.of<Tasks>(context).findById(id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(TaskDetailsScreen.routeName, arguments: task.id);
        },
        child: Card(
          color: Theme.of(context).canvasColor,
          margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
          elevation: 10,
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Text(index.toString(), style: Theme.of(context).textTheme.displaySmall),
                ),
                title: Text(task.title, style: Theme.of(context).textTheme.displayLarge,),
                subtitle: Text(task.dueDate, style: Theme.of(context).textTheme.displayMedium,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AddTaskScreen.routeName, arguments: task.id);
                      },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                      onPressed: () {
                        Provider.of<Tasks>(context, listen: false).deleteTask(task.id);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red,),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
