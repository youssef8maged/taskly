import 'package:flutter/material.dart';
import 'package:todo/Helpers/methods.dart';

class NotificationDetails extends StatelessWidget {
  const NotificationDetails({
    super.key,
    required this.payload,
  });

  final String payload;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Methods().showOutput("NotificationDetails built");
    final List<String> payloadList = payload.split("|");
    return Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(50)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.text_format,
                  size: 30, color: theme.colorScheme.secondary),
              const SizedBox(
                width: 8,
              ),
              Text(
                "Title :",
                style: theme.textTheme.headlineSmall!.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            payloadList[0],
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Icon(Icons.description,
                  size: 30, color: theme.colorScheme.secondary),
              const SizedBox(
                width: 8,
              ),
              Text(
                "Note :",
                style: theme.textTheme.headlineSmall!.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            payloadList[1],
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(
            height: 40,
          ),
        
          Row(
            children: [
              Icon(Icons.access_time,
                  size: 30, color: theme.colorScheme.secondary),
              const SizedBox(
                width: 8,
              ),
              Text(
                "Time :",
                style: theme.textTheme.headlineSmall!.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Spacer(),
              Text(
                payloadList[3],
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 40,),
            Row(
            children: [
              Icon(Icons.calendar_today,
                  size: 30, color: theme.colorScheme.secondary),
              const SizedBox(
                width: 8,
              ),
              Text(
                "Created On :",
                style: theme.textTheme.headlineSmall!.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Spacer(),
              Text(
                payloadList[2],
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}



  // @override
  // Widget build(BuildContext context) {
  //   Methods().showOutput("NotificationDetails built");
  //   return Container(
  //     margin: const EdgeInsets.all(20),
  //     padding: const EdgeInsets.all(15),
  //     decoration: BoxDecoration(
  //         color: Colors.blueGrey,
  //         borderRadius: BorderRadius.circular(50)),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Row(
  //             children: [
  //               Icon(Icons.text_format,
  //                   size: 30, color: Colors.white),
  //               Text(
  //                 "Title ",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           Text(
  //             payload.split("|")[0],
  //             style: const TextStyle(
  //               color: Colors.black,
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           const Row(
  //             children: [
  //               Icon(
  //                 Icons.description,
  //                 size: 30,
  //                 color: Colors.white,
  //               ),
  //               Text(
  //                 "Description",
  //                 style: TextStyle(color: Colors.white, fontSize: 20),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           Text(
  //             payload.split("|")[1],
  //              style: const TextStyle(
  //               color: Colors.black,
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           const Row(
  //             children: [
  //               Icon(
  //                 Icons.calendar_today,
  //                 size: 30,
  //                 color: Colors.white,
  //               ),
  //               Text(
  //                 "Date",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(
  //             height: 500,
  //           ),
  //           Text(
  //             payload.split("|")[2],
  //              style: const TextStyle(
  //               color: Colors.black,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

