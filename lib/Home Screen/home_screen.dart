import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/Helpers/methods.dart';
import 'package:todo/Logic/my_notification.dart';
import 'package:todo/Logic/my_theme_mode.dart';
import 'package:todo/Home%20Screen/Task%20Tile/task_tile.dart';
import 'package:todo/Home%20Screen/add_task_button.dart';
import 'package:todo/Home%20Screen/no_tasks.dart';
import 'package:todo/Home%20Screen/today.dart';
import 'package:todo/Modules/task.dart';
import 'package:todo/Modules/task_controller.dart';
import 'package:todo/Notification%20Screen/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  const HomeScreen({
    super.key,
    this.notificationAppLaunchDetails,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MyThemeMode myThemeMode = MyThemeMode();
  final TaskController taskController = TaskController();
  final DatePickerController datePickerController = DatePickerController();
  DateTime selectedDate = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Methods().showOutput('HomeScreen didChangeDependencies');
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Methods().showOutput('HomeScreen didUpdateWidget');
  }

  @override
  void deactivate() {
    super.deactivate();
    // Methods().showOutput('HomeScreen deactivate');
  }

  @override
  void dispose() {
    super.dispose();
    // Methods().showOutput('HomeScreen dispose');
  }

  @override
  void initState() {
    super.initState();
    // Methods().showOutput('HomeScreen initState');
    listenToNotificationStream();
    checkNotificationLaunch();
    taskController.assignTasks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      datePickerController.animateToSelection();
    });
  }

  Future<void> checkNotificationLaunch() async {
    await Future.sync(() {
      return null;
    });
    final NotificationAppLaunchDetails? details =
        widget.notificationAppLaunchDetails;
    if (details != null && details.didNotificationLaunchApp) {
      Methods().showOutput("App opened by notification");
      await openNotificationScreen(details.notificationResponse!);
    } else {
      Methods().showOutput("App opened by normal way");
    }
  }

  void listenToNotificationStream() {
    MyNotification.responseStreamController.stream.listen(
      (NotificationResponse res) async {
        await openNotificationScreen(res);
      },
    );
  }

  Future<void> openNotificationScreen(NotificationResponse res) async {
    Methods().showOutput("Notification ID: ${res.id}");
    if (mounted) {
       await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return NotificationScreen(payload: res.payload!);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Methods().showOutput('HomeScreen built');
    final ThemeData theme = Theme.of(context);
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isDarkMode = Get.isDarkMode;
    // final bool isDarkMode = theme.colorScheme.brightness == Brightness.dark;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? obj) async {
        if (didPop) return;
        final bool? shouldPop = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext ctx) => AlertDialog(
            title: const Text('Confirm Exit'),
            content: const Text('Are you sure you want to exit ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop<bool>(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop<bool>(true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        if (shouldPop == true && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Taskly",
              style: GoogleFonts.lobster(fontSize: 32, letterSpacing: 2),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              myThemeMode.setThemeMode(toLight: isDarkMode ? true : false);
            },
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "pics/todo_icon.png",
              ),
            ),
          ],
          elevation: 1,
          backgroundColor: theme.colorScheme.primaryContainer,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Today(),
                    AddTaskButton(controller:  datePickerController,),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                DatePicker(
                  DateTime.now().subtract(const Duration(days: 365)),
                  daysCount: 730,
                  controller: datePickerController,
                  monthTextStyle: theme.textTheme.titleSmall!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  dateTextStyle: theme.textTheme.titleSmall!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  dayTextStyle: theme.textTheme.titleSmall!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  selectionColor: isDarkMode
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.primary,
                  initialSelectedDate: selectedDate,
                  onDateChange: (DateTime date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                  height: 110,
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () {
                    bool atLeastOneTask = false;
                    // Methods().showOutput('Obx called');
                    return taskController.tasks.isEmpty
                        ? const NoTasks()
                        : orientation == Orientation.portrait
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: taskController.tasks.length,
                                itemBuilder: (BuildContext ctx, int idx) {
                                  final Task task = taskController.tasks[idx];
                                  TaskTile? taskTile = filterTask(task);
                                  if (taskTile != null &&
                                      atLeastOneTask == false) {
                                    atLeastOneTask = true;
                                  }
                                  if (idx == taskController.tasks.length - 1 &&
                                      !atLeastOneTask) {
                                    return const NoTasks();
                                  }
                                  return taskTile ?? const SizedBox.shrink();
                                },
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: taskController.tasks
                                    .asMap()
                                    .entries
                                    .map<Widget>((MapEntry<int, Task> entry) {
                                  final int idx = entry.key;
                                  final Task task = entry.value;
                                  TaskTile? taskTile = filterTask(task);
                                  if (taskTile != null &&
                                    atLeastOneTask == false) {
                                    atLeastOneTask = true;
                                  }
                                  if (idx ==
                                      taskController.tasks.length - 1 &&
                                    !atLeastOneTask) {
                                    return const NoTasks();
                                  }
                                  return taskTile ?? const SizedBox.shrink();
                                  }).toList(),
                                ),
                              );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  TaskTile? filterTask(Task taskP) {
    final String selectedDateFormated = DateFormat('dd/MM/yyyy').format(selectedDate);
    // final String selectedDateFormated = DateFormat.yMd().format(selectedDate);
    final DateTime taskDate = DateFormat('dd/MM/yyyy').parse(taskP.date);
    if (taskDate.isAfter(selectedDate)) return null;
    final bool isFiltered = (taskP.date == selectedDateFormated ) || ( taskP.repeat == 'Daily' ) || (taskP.repeat == 'Weekly' && selectedDate.weekday == taskDate.weekday) || (taskP.repeat == 'Monthly' && selectedDate.day == taskDate.day);
    return isFiltered ? TaskTile(task: taskP) : null;
  }

}
