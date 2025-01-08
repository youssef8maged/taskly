import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/Add%20Task%20Screen/add_task_screen.dart';

class AddTaskButton extends StatelessWidget {
  final DatePickerController controller;
  const AddTaskButton({
    super.key, required this.controller,
  });


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () async {
         final String? formatedDate = await Get.to<String>(
          () {
            return const AddTaskScreen();
          },
          transition: Transition.cupertinoDialog,
          duration: const Duration(milliseconds: 1000),
        );
        if (formatedDate != null) {
          controller.animateToDate(DateFormat('dd/MM/yyyy').parse(formatedDate));
          // controller.animateToDate(DateFormat.yMd().parse(formatedDate));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.add,
            color: theme.colorScheme.onPrimary,
          ),
          Text(
            "Add Task",
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
