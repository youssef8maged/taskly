import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/Helpers/methods.dart';
import 'package:todo/Logic/my_db.dart';
import 'package:todo/Logic/my_notification.dart';
import 'package:todo/Modules/task.dart';

class TaskController  {

  
  final List<Task> tasks = <Task>[].obs;
  
  
  TaskController._internal();
  static final TaskController _instance = TaskController._internal();
  factory TaskController() => _instance;
  

  Future<int> addTask(Task task) async {
    final int taskID = await MyDb().insertTask(task);
    Methods().showOutput('Task Added with ID: $taskID');
    await assignTasks();
    return taskID;
  }

Future<int> deleteTask(Task task) async{
    final int rowsDeleted = await MyDb().deleteTask(task);
    Methods().showOutput('$rowsDeleted row deleted');
    await assignTasks();
   return rowsDeleted;
  }

  Future<int> updateTask(Task task) async{
   final int rowsUpdated =  await MyDb().updateTask(task);
   Methods().showOutput('$rowsUpdated row updated');
   await assignTasks();
  
   return rowsUpdated;
  }

  Future<void> assignTasks() async {
    final List<Map<String, Object?>> loadedTasks = await MyDb().getTasks();
    final List<Task> formatedTasks = loadedTasks.map((Map<String, Object?> taskMap) {
      return Task.fromUint8List(
      taskMap['id'] as int,
      taskMap['task'] as Uint8List,
      );
    }).toList();

    formatedTasks.sort((Task a, Task b) {
      final TimeOfDay timeA = MyNotification().parseFormattedTime(a.time)!;
      final TimeOfDay timeB = MyNotification().parseFormattedTime(b.time)!;
      return timeA.hour.compareTo(timeB.hour) != 0
          ? timeA.hour.compareTo(timeB.hour)
          : timeA.minute.compareTo(timeB.minute);
    });

    tasks.assignAll(formatedTasks);
    Methods().showOutput('Tasks Refreshed');
  }
  

  
}