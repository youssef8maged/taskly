import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as la;
import 'package:todo/Helpers/methods.dart';
import 'package:todo/Modules/task.dart';

class MyNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final StreamController<NotificationResponse> responseStreamController = StreamController();

  MyNotification._privateConstructor();
  static final MyNotification _instance = MyNotification._privateConstructor();
  factory MyNotification() => _instance;


  Future<void> initNotification() async {
    InitializationSettings initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    final bool isInizialized = await flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveBackgroundNotificationResponse: onResponse,
          onDidReceiveNotificationResponse: onResponse,
        ) ??
        false;

    Methods().showOutput("Notification Inizialization is $isInizialized");
  }


  Future<bool> requestNotificationPermission(BuildContext ctx) async {
    final PermissionStatus status = await Permission.notification.status;

    if (status.isDenied) {
      PermissionStatus newStatus = await Permission.notification.request();
      if (newStatus.isGranted) {
        Methods().showOutput('Notification Permission Granted.');
        return true;
      } else {
        Methods().showOutput('Notification Permission Denied.');
        return false;
      }
    } else if (status.isPermanentlyDenied && ctx.mounted) {
      Methods().showOutput('Notification Permission Permanently Denied');
      final bool isAgreed = await showDialog(
            barrierDismissible: false,
            context: ctx,
            builder: (BuildContext ctx) => AlertDialog(
              title: const Text('Permission Required'),
              content: const Text(
                  'Please allow showing notifications to get notified'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop<bool>(true),
                  child: const Text('Allow'),
                ),
              ],
            ),
          ) ??
          false;
      if (!isAgreed) {
        Methods().showOutput('Refused opening settings');
        return false;
      }
      bool opened = await openAppSettings();
      Methods().showOutput('App Settings is: $opened Opened');
      return false;
    } else if (status.isRestricted && ctx.mounted) {
      Methods().showOutput('Notification Permission Restricted.');
      Methods().showScaffold(ctx, "Notification Permission is Restricted");
      return true;
    } else if (status.isLimited && ctx.mounted) {
      Methods().showOutput('Notification Permission Limited');
      Methods().showScaffold(ctx, "Notification Permission is Limited");
      return true;
    } else {
      Methods().showOutput('Notification Permission Granted');
      return true;
    }
  }


  Future<void> showTaskNotification(Task task) async {
    la.initializeTimeZones();
    final String localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.Location myLocation = tz.getLocation(localTimeZone);
    tz.setLocalLocation(myLocation);
    //now tz.local is same as myLocation
    final tz.TZDateTime currentTime = tz.TZDateTime.now(tz.local);
    Methods().showOutput("current hour is ${currentTime.hour}");

    TimeOfDay taskTime = parseFormattedTime(task.time)!;
    taskTime = taskTime.replacing(
      minute: taskTime.minute - task.remind,
    );

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      taskTime.hour,
      taskTime.minute,
    );

    // if (scheduledDate.isBefore(currentTime)) {
    //   scheduledDate = scheduledDate.add(const Duration(days: 1));
    // }


     AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      '0',
      'Taskly Reminders',
      priority: Priority.max,
      importance: Importance.max,
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails();

     NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id,
      "Taskly",
      task.title,
      scheduledDate ,
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: "${task.title}|${task.note}|${task.date}|${task.time}|${task.repeat}",
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    Methods().showOutput("Task ${task.title} Notification Scheduled at $scheduledDate");
  }

  Future<void> cancelNotification(int idP) async {
    await flutterLocalNotificationsPlugin.cancel(idP);
    Methods().showOutput("Notification with id $idP is Cancelled");
  }

  Future<NotificationAppLaunchDetails?> getNotificationDetails() async {
    return await flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
  }
  

TimeOfDay? parseFormattedTime(String formattedTime) {
  final RegExp timeRegExp = RegExp(r'^(\d{1,2}):(\d{2})\s*([APMapm]{2})?$');
  final RegExpMatch? match = timeRegExp.firstMatch(formattedTime.trim());

  if (match != null) {
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)?.toUpperCase();

    if (period == null) {
      // 24-hour format
      if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
        return TimeOfDay(hour: hour, minute: minute);
      }
    } else if (period == 'AM' || period == 'PM') {
      // 12-hour format
      if (hour > 0 && hour <= 12 && minute >= 0 && minute < 60) {
        final adjustedHour = (period == 'PM' && hour != 12)
            ? hour + 12
            : (period == 'AM' && hour == 12)
                ? 0
                : hour;
        return TimeOfDay(hour: adjustedHour, minute: minute);
      }
    }
  }

  // Return null if parsing fails
  return null;
}


  
}

@pragma('vm:entry-point')
void onResponse(NotificationResponse resValue) {
  MyNotification.responseStreamController.add(resValue);
}



  // Future<bool> checkPermission() async {
  //   final bool isAllowed;
  //   if (Platform.isAndroid) {
  //     final AndroidFlutterLocalNotificationsPlugin?
  //         androidFlutterLocalNotificationsPlugin =
  //         flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin>();
  //     isAllowed = await androidFlutterLocalNotificationsPlugin
  //         ?.requestNotificationsPermission() ?? false;
  //   } else if (Platform.isIOS) {
  //     final IOSFlutterLocalNotificationsPlugin?
  //         iosFlutterLocalNotificationsPlugin =
  //         flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
  //             IOSFlutterLocalNotificationsPlugin>();
  //     isAllowed =
  //         await iosFlutterLocalNotificationsPlugin?.requestPermissions(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     ) ?? false;
  //   } else{
  //     isAllowed = false;
  //   }
  //   return isAllowed;
  // }


  // Future<void> showBasicNotification() async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     'basic_channel_id',
  //     'basic_channel_name',
  //     priority: Priority.max,
  //     importance: Importance.max,
  //   );
  //   const DarwinNotificationDetails darwinNotificationDetails =
  //       DarwinNotificationDetails();
  //   const NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidNotificationDetails,
  //     iOS: darwinNotificationDetails,
  //   );
  //   await flutterLocalNotificationsPlugin.show(
  //     1,
  //     'basic_title',
  //     'basic_body',
  //     notificationDetails,
  //     payload: "basic_payload",
  //   );
  // }
