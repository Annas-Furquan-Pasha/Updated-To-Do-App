import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_task_screen.dart';
import '../provider/tasks.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({Key? key}) : super(key: key);

  static const routeName = '/task-details-screen';

  @override
  Widget build(BuildContext context) {
    final navigation = Navigator.of(context);
    final tryId = ModalRoute.of(context)!.settings.arguments;
    if(tryId == null ) {
      return const Scaffold(body: Center(child: Text('Task not found'),),);
    }
    final task = Provider.of<Tasks>(context, listen: false).findById(tryId as String);

     return Scaffold(
       appBar: AppBar(
         title: Text(task.title),
         elevation: 0,
         actions: [
           IconButton(
               onPressed: () async {
                 await navigation.pushNamed(AddTaskScreen.routeName, arguments: task.id);
                 navigation.pop();
               },
               icon: const Icon(Icons.edit),
           ),
           const SizedBox(width: 5,),
         ]
       ),
       body: SingleChildScrollView(
         child: Column(
           children: [
             const Text('Description'),
             const SizedBox(height: 5,),
             Text(task.description),
             const SizedBox(height: 10),
             const Text('Due Date'),
             const SizedBox(height: 5,),
             Text(task.dueDate),
             const Text('Due Time'),
             const SizedBox(height: 5,),
             Text(task.dueTime),
           ],
         ),
       ),
     );
  }
}
