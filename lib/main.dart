import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/task_details_screen.dart';
import './screens/task_screen.dart';
import './screens/add_task_screen.dart';
import './provider/tasks.dart';

void main() => runApp(
    ChangeNotifierProvider(
  create: (_) => Tasks(),
  child:   MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const TaskScreen(),
    title: 'TO-DO',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(secondary: Colors.amber),
      canvasColor: const Color.fromRGBO(255, 254, 229, 1),
      fontFamily: 'Raleway',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'RobotoCondensed'),
        displayMedium: TextStyle(fontSize: 15, fontFamily: 'RobotoCondensed'),
        displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'RobotoCondensed', color: Colors.black),
        titleLarge: TextStyle(fontSize: 25, fontFamily: 'Raleway', color: Colors.white),
      )
    ),
    routes: {
      TaskScreen.routeName : (_) => const TaskScreen(),
      AddTaskScreen.routeName : (_) => const AddTaskScreen(),
      TaskDetailsScreen.routeName : (_) => const TaskDetailsScreen(),
    },
  ),
)
);