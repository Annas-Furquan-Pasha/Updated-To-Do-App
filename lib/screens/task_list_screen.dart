import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/favorites_widget.dart';
import '../widgets/task_list_widget.dart';
import '../models/task.dart';
import '../provider/tasks.dart';

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
        title: Text('Enter List Name', style: Theme.of(context).textTheme.titleSmall,),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                label: const Text('List',),
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
                if(controller.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(
                        content:  Text('List Name cannot be empty !!'),
                        duration: Duration(seconds: 3),
                  )
                  );
                } else {
                if(taskList.lId == '') {
                  Provider.of<Tasks>(context, listen: false).addList(
                      TaskList('', controller.text, []));
                  Navigator.of(ctx).pop();
                } else {
                  Provider.of<Tasks>(context, listen: false)
                      .updateListName(taskList.lId, TaskList(taskList.lId, controller.text, taskList.tasksList));
                  Navigator.of(ctx).pop();
                }
                }
                }, child: taskList.lId == '' ? const Text('Add') : const Text('Rename')
              ),
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
      body: Column(
        children: [
          ListTile(
            title: const Text('Favorites', style: TextStyle(fontWeight: FontWeight.bold),),
            trailing: Switch(
              value: Provider.of<Tasks>(context).switchFavorite,
              onChanged: (val)=> Provider.of<Tasks>(context, listen: false).changeFavoriteStatus(val)
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<Tasks>(context, listen: false).fetchAndSetTasks(),
              builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator(),)
                  : Provider.of<Tasks>(context, listen: false).switchFavorite
                  ? const FavoritesWidget()
                  : TaskListWidget(alertDialog),
            ),
          ),
        ],
      ),
    );
  }
}

