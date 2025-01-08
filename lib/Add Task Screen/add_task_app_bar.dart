
import 'package:flutter/material.dart';

class AddTaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AddTaskAppBar({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    // Methods().showOutput('AddTaskAppBar built');
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Add Task",
      ),
      actions: [
         Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "pics/todo_icon.png",
              ),
          ),
      ],
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
