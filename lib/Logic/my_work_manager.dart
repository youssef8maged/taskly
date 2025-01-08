import 'package:todo/Helpers/methods.dart';
import 'package:todo/Logic/my_notification.dart';
import 'package:todo/Modules/task.dart';
import 'package:workmanager/workmanager.dart';

class MyWorkManager {


  MyWorkManager._privateConstructor();
  static final MyWorkManager _instance = MyWorkManager._privateConstructor();
  factory MyWorkManager() => _instance;

  Future<void> initWorkManager() async {
    await Workmanager().initialize(actionTask);
    Methods().showOutput("WorkManager Inizialization is done");
  }

  Future<void> registerTaskNotification(Task task,int id) async {
    late final Duration freq;

    switch (task.repeat) {
      case "None":
        freq = const Duration(days: 365);
        break;
      case "Daily":
        freq = const Duration(days: 1);
        break;
      case "Weekly":
        freq = const Duration(days: 7);
        break;
      case "Monthly":
        freq = const Duration(days: 30);
        break;
      default: 
         freq = const Duration(days: 365);
    }

    Map<String, dynamic> newInputData = <String, dynamic>{
          "id": id,
          "title": task.title,
          "note": task.note,
          "date": task.date,
          "time": task.time,
          "remind": task.remind,
          "repeat": task.repeat,
          "colorID": task.colorID,
          "isCompleted" : task.isCompleted,
        };

    await Workmanager().registerPeriodicTask(
      "$id",
      "task_notification",
      inputData: newInputData,
      frequency: freq ,
      );

        Methods().showOutput("registerTaskNotification called with id $id");
  }

  Future<void> unregisterTaskNotification(String idP) async {
    await Workmanager().cancelByUniqueName(idP);
    Methods().showOutput("Notification with id $idP is unregistered");
    await MyNotification().cancelNotification(int.parse(idP));
  }


}

@pragma('vm:entry-point')
void actionTask() {
  Workmanager().executeTask(
    (String taskName, Map<String, dynamic>? inputData) async {
      final Task task = Task(
        id: inputData!['id'] as int,
        title: inputData['title'] as String,
        note: inputData['note'] as String,
        date: inputData['date'] as String,
        time: inputData['time'] as String,
        remind: inputData['remind'] as int,
        repeat: inputData['repeat'] as String,
        colorID: inputData['colorID'] as int,
        isCompleted: inputData['isCompleted'] as int,
      );
      
       await MyNotification().showTaskNotification(task);
      Methods().showOutput("ExcuteTask called with id ${inputData['id'] as int}");

      return Future.value(true);
    },
  );
}
