import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/Helpers/methods.dart';
import 'package:todo/Notification%20Screen/notification_details.dart';

class NotificationScreen extends StatelessWidget {
  final String payload;
  const NotificationScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Methods().showOutput("NotificationScreen built");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("Reminder",
            style: theme.textTheme.headlineSmall
        ),
        leading: IconButton(
          onPressed: () {
            Get.back<String>(result: "Returned from NotificationScreen");
          },
          icon:   const Icon(
            Icons.arrow_back,
          ),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary,
                    offset: const Offset(0, 8),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_active,
                    size: 32,
                    color: theme.colorScheme.onPrimary,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "check your ${getReminder()} task",
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            NotificationDetails(payload: payload),
          ],
        ),
      ),
    );
  }

  String getReminder(){
    String reminder = payload.split('|').last;
    switch (reminder) {
      case "None":
      reminder = "one-time";
      break;
      case "Daily":
      reminder = "daily";
      break;
      case "Weekly":
      reminder = "weekly";
      break;
      case "Monthly":
      reminder = "monthly";
      break;
      default:
      reminder = "";
    }
    return reminder;
  }


}
