import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../provider/tasks.dart';
import './task_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  static const routeName = '/task-list-screen';


  void alertDialog(BuildContext context, TaskList taskList) {
    final controller = TextEditingController();
    if(taskList.lId != '') {
      controller.text = taskList.title;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Enter Category Name', style: Theme.of(context).textTheme.titleSmall,),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                label: const Text('Category',),
              ),
            ),
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment : MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: () {
                Navigator.of(ctx).pop();
              }, child: const Text('cancel')),
              ElevatedButton(onPressed: () {
                if(taskList.lId == '') {
                  Provider.of<Tasks>(context, listen: false).addList(
                      TaskList('', controller.text, []));
                  Navigator.of(ctx).pop();
                } else {
                  Provider.of<Tasks>(context, listen: false)
                      .updateListName(taskList.lId, TaskList(taskList.lId, controller.text, taskList.tasksList));
                  Navigator.of(ctx).pop();
                }
              }, child: taskList.lId == '' ? const Text('Add') : const Text('Rename')),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final tasksList = Provider.of<Tasks>(context).tasks;
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do', style: Theme.of(context).textTheme.titleLarge,),
        elevation: 0,
        actions: [
          IconButton(onPressed: () => alertDialog(context, TaskList('', '')), icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Tasks>(context, listen: false).fetchAndSetTasks(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator(),)
            : Consumer<Tasks>(
          builder: (ctx, tasksList, ch) => tasksList.tasks.isEmpty
              ? ch!
              :ListView.builder(
            itemCount: tasksList.tasks.length,
              itemBuilder: (_, index) => Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(top: 8, right: 8, left: 8,),
                child: Card(
                  elevation: 5,
                  child: Stack(
                    children: [
                      ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(TaskScreen.routeName, arguments: tasksList.tasks[index].lId);
                      },
                      leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.secondary,child: Text(index.toString(),style: Theme.of(context).textTheme.displaySmall,),),
                      title: Text(tasksList.tasks[index].title, style: Theme.of(context).textTheme.displayLarge,),
                      //trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.red,),),
                    ),
                      Positioned(
                          right: 8,
                          child: DropdownButton(
                            underline: Container(),
                            icon: const Icon(Icons.more_vert),
                            items: [
                              DropdownMenuItem(
                                value: 'Rename',
                                  child: Row(
                                    children: const [
                                      Icon(Icons.drive_file_rename_outline),
                                      SizedBox(width: 5,),
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
                                alertDialog(context, tasksList.tasks[index]);
                              } else if(value == 'Delete') {
                                Provider.of<Tasks>(context, listen: false).deleteList(tasksList.tasks[index].lId);
                              }
                            },
                          ),
                      ),
                  ]
                  ),
                ),
              ),
          ),
          child: const Center(child:Text('No tasks yet, try to add some')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => alertDialog(context, TaskList('', '')),
        child: const Icon(Icons.add,),
      ),
    );
  }
}
