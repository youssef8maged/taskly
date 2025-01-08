import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/Add%20Task%20Screen/add_task_app_bar.dart';
import 'package:todo/Add%20Task%20Screen/color_avatars.dart';
import 'package:todo/Add%20Task%20Screen/date_text_field.dart';
import 'package:todo/Add%20Task%20Screen/note_text_field.dart';
import 'package:todo/Add%20Task%20Screen/remind_text_field.dart';
import 'package:todo/Add%20Task%20Screen/repeat_text_field.dart';
import 'package:todo/Add%20Task%20Screen/time_text_field.dart';
import 'package:todo/Logic/my_notification.dart';
import 'package:todo/Logic/my_task_options.dart';
import 'package:todo/Logic/my_work_manager.dart';
import 'package:todo/Modules/task.dart';
import 'package:todo/Modules/task_controller.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    super.key,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final MyTaskOptions myTaskOptions = MyTaskOptions();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedTime = DateFormat('hh:mm a').format(DateTime.now());
  late int selectedReminder;
  late String selectedRepeat;
  late Color selectedColor;

  @override
  void initState() {
    // Methods().showOutput('AddTaskScreen initialized');
    super.initState();
    selectedReminder = myTaskOptions.reminders.first;
    selectedRepeat = myTaskOptions.repeats.first;
    selectedColor = myTaskOptions.colors[1] as Color;
  }

  @override
  void dispose() {
    // Methods().showOutput('AddTaskScreen disposed');
    super.dispose();
    titleController.dispose();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Methods().showOutput('AddTaskScreen built');
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: const AddTaskAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mediaQuery.size.width * 0.1,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Title",
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  suffix: const Icon(
                    Icons.text_format,
                  ),
                  hintText: 'Enter task name...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                controller: titleController,
              ),
              const SizedBox(height: 20),
              Text(
                "Note",
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 10,
              ),
              NoteTextField(noteController: noteController),
              const SizedBox(height: 20),
              Text(
                "Date",
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 10,
              ),
              DateTextField(
                selectedDate: selectedDate,
                onDateSelected: (DateTime date) {
                  setState(
                    () {
                      selectedDate = date;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              TimeTextField(
                selectedTime: selectedTime,
                onTimeSelected: (String time) {
                  setState(() {
                    selectedTime = time;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                "Remind",
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 10,
              ),
              RemindTextField(
                selectedReminder: selectedReminder,
                onReminderSelected: (int? value) {
                  setState(() {
                    selectedReminder = value!;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Repeat",
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              RepeatTextField(
                selectedRepeat: selectedRepeat,
                onSelectedRepeat: (String? value) {
                  setState(() {
                    selectedRepeat = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Color",
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ColorAvatars(
                          selectedColor: selectedColor,
                          onSelectedColor: (Color color) {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await validateData(ctx: context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondaryContainer,
                      ),
                      child: Text(
                        "Create !",
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> validateData({required BuildContext ctx}) async {
    if (checkTime(ctx) == false) {
      ctx.mounted? errorSnackBar(ctx, "Invalid Time", "The reminder already passed"):null;
    }
    else if ( titleController.text.trim().isNotEmpty &&
        noteController.text.trim().isNotEmpty) {
         final bool  isNotificationAllowed = await MyNotification().requestNotificationPermission(ctx);
          if (!isNotificationAllowed && ctx.mounted) {
            errorSnackBar(ctx, "Permission Required", "Please allow notification permission to get notified");
            return;
          }
      final Task taskObj = prepareTask();
      final int taskID = await TaskController().addTask(taskObj);
      await MyWorkManager().registerTaskNotification(taskObj,taskID);

      Get.back<String>(
        result: taskObj.date,
      );

      ctx.mounted ? infoSnackBar(ctx,"Task Added", "Be ready, A notification will alert you at the right time"):null;

    } else {
      ctx.mounted? errorSnackBar(ctx, "Fields Required", "Please fill all the fields"):null;
    }
  }

  bool checkTime(BuildContext ctx) {
     final TimeOfDay taskTime = MyNotification().parseFormattedTime(selectedTime)!;

    final DateTime taskDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      taskTime.hour,
      taskTime.minute,
    ).subtract(Duration(minutes: selectedReminder));
    
    if (taskDateTime.isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }

  void infoSnackBar(BuildContext ctxP,String title , String message) {
    final ThemeData theme = Theme.of(ctxP);
    Get.snackbar(
      title,
      message ,
      animationDuration: const Duration(seconds: 1),
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(
        Icons.info,
        color: theme.colorScheme.primary,
      ),
      backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
      showProgressIndicator: true,
      duration: null, // Keep the snackbar open indefinitely
      mainButton: TextButton(
        onPressed: () async {
          await Get
              .closeCurrentSnackbar(); // Close the snackbar on button press
        },
        child: Text(
          "Done",
          style: TextStyle(color: theme.colorScheme.primary),
        ),
      ),
    );
  }

  void errorSnackBar(BuildContext ctx, String title, String message) {
    final ThemeData theme = Theme.of(ctx);
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(
        Icons.warning_amber_rounded,
        color: theme.colorScheme.error,
      ),
      backgroundColor: theme.colorScheme.onError.withValues(alpha: 0.8),
    );
  }

  Task prepareTask() {
    final int selectedColorId = myTaskOptions.colors.entries
        .firstWhere(
            (MapEntry<int, Color> entry) => entry.value == selectedColor)
        .key;
    final String selectedDateFormated = DateFormat('dd/MM/yyyy').format(selectedDate);
    // final String selectedDateFormated = DateFormat.yMd().format(selectedDate);

    final Task task = Task(
      isCompleted: 0,
      id: 0,
      title: titleController.text,
      note: noteController.text,
      date: selectedDateFormated,
      time: selectedTime,
      remind: selectedReminder,
      repeat: selectedRepeat,
      colorID: selectedColorId,
    );
    return task;
  }

}
