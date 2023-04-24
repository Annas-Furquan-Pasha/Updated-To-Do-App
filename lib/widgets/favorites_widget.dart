import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './task_card.dart';
import '../provider/tasks.dart';

class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Tasks>(
      builder: (ctx, tasksList, ch) => tasksList.favorites.isEmpty
          ? ch!
          : ListView.builder(
        itemCount: tasksList.favorites.length,
        itemBuilder: (_, index) => TaskCard(tasksList.favorites[index].lId, tasksList.favorites[index].id, index)
      ),
      child: const Center(child:Text('No favorites yet!! Try to add some')),
    );
  }
}
