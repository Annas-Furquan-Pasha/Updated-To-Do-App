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
    // final items = Provider.of<Tasks>(context).tasks;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks', style: Theme.of(context).textTheme.titleLarge,),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddTaskScreen.routeName);
              },
              icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Tasks>(context, listen: false).fetchAndSetTasks(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator(),)
            : Consumer<Tasks>(
              builder: (ctx, task, ch) => task.tasks.isEmpty
                  ? ch!
                  : ListView.builder(
                itemCount: task.tasks.length,
                itemBuilder: (_, index) => TaskCard(
                  task.tasks[index].id,
                  index
               ),
            ),
          child: const Center(child: Text('No Tasks Yet, Try to Add Some'),),
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddTaskScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
