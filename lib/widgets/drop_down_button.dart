import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../provider/tasks.dart';

class DropDownButtonWidget extends StatelessWidget {

  final TaskList tasksList;
  final void Function(BuildContext context, TaskList taskList) alertDialog;

  const DropDownButtonWidget(this.tasksList, this.alertDialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      underline: Container(),
      icon: const Icon(Icons.more_vert),
      items: [
        DropdownMenuItem(
          value: 'Rename',
          child: Row(
            children: const [
              Icon(Icons.drive_file_rename_outline),
              SizedBox(width: 10,),
              Text('Rename'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'Delete',
          child: Row(
            children: const [
              Icon(Icons.delete, color: Colors.red,),
              SizedBox(width: 5,),
              Text('Delete'),
            ],
          ),
        ),
      ],
      onChanged: (value) {
        if(value == 'Rename') {
          alertDialog(context, tasksList);
        } else if(value == 'Delete') {
          showDialog(context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Are you Sure ? ', style: Theme.of(context).textTheme.titleSmall,),
                content: const Text('All the tasks under this category will be deleted, you cannot recover them again.\n'
                    'Do you still want to continue ? '),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: () {
                        Navigator.of(ctx).pop();
                      }, child: const Text('No')),
                      ElevatedButton(onPressed: () {
                        Provider.of<Tasks>(context, listen: false).deleteList(tasksList.lId);
                        Navigator.of(ctx).pop();
                      }, child: const Text('Yes')),
                    ],
                  ),
                ],
              ),
          );
        }
      },
    );
  }
}
