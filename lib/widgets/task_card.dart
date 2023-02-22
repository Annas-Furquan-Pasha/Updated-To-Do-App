import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/task_details_screen.dart';
import '../screens/add_task_screen.dart';
import '../provider/tasks.dart';

class TaskCard extends StatelessWidget {

  final String lId;
  final String id;
  final int index;
  const TaskCard(this.lId, this.id, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    final task = Provider.of<Tasks>(context).findById(lId, id);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Dismissible(
        key: ValueKey(id),
        background: Container(
          color: Colors.redAccent,
          margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: const Icon(Icons.delete, color: Colors.white, size: 30,),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) async {
          if(direction == DismissDirection.endToStart) {
            Provider.of<Tasks>(context, listen: false).deleteTask(lId, task.id);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(TaskDetailsScreen.routeName, arguments: [lId, task.id]);
            },
            child: Card(
              color: const Color.fromRGBO(255, 254, 229, 1),
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
                            Navigator.of(context).pushNamed(AddTaskScreen.routeName, arguments: [lId, task.id]);
                          },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                          onPressed: () {
                            Provider.of<Tasks>(context, listen: false).deleteTask(lId, task.id);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red,),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
