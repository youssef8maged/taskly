import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/Logic/my_work_manager.dart';
import 'package:todo/Modules/task.dart';
import 'package:todo/Modules/task_controller.dart';

class SheetContent extends StatelessWidget {
  final  Task task;
  final AnimationController animationController;
  const SheetContent({super.key, required this.task, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final ThemeData  theme = Theme.of(context);
    final MediaQueryData media = MediaQuery.of(context);
    return   Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64,vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            SizedBox(
            width: media.size.width * 0.5,
            child: task.isCompleted == 1
              ? const SizedBox.shrink()
              : ElevatedButton(
                onPressed: () async {
                  Get.back<String>(result: "updated");
                  await MyWorkManager().unregisterTaskNotification(task.id.toString());
                  task.isCompleted = 1;
                  await TaskController().updateTask(task);
                },
                child: const Center(
                  child: Text("Complete Task"),
                ),
                ),
            ),
            SizedBox(
            width: media.size.width * 0.5,
            child: ElevatedButton(
              onPressed: () async{
                Get.back<String>(result:  "deleted");
                task.isCompleted == 0 ? await MyWorkManager().unregisterTaskNotification(task.id.toString()) : null;
                await animationController.reverse();
                await TaskController().deleteTask(task);
              },
              style:  ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error.withValues(alpha: 0.75),
                foregroundColor: theme.colorScheme.onError,
                ),
              child: const Center(
              child: Text("Delete Task"),
              )
            ),
            ),
           Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: CircleAvatar(
              radius: 4,
              backgroundColor: theme.colorScheme.tertiaryContainer,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: CircleAvatar(
              radius: 4,
                            backgroundColor: theme.colorScheme.tertiaryContainer,

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: CircleAvatar(
              radius: 4,
                            backgroundColor: theme.colorScheme.tertiaryContainer,

              ),
            ),
            ],
          ),
          SizedBox(
            width: media.size.width * 0.3,
            child: ElevatedButton(
              onPressed: () {
                Get.back<String>(result:  "canceled");
              },
              child: const Center(
                child: Text("Cancel"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
