import 'package:flutter/material.dart';

class TimeTextField extends StatelessWidget {
  const TimeTextField({
    super.key,
    required this.selectedTime,
     required this.onTimeSelected,
  });

  final void Function (String) onTimeSelected;
  final String selectedTime;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Time",
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: () async{
                await pickTime( ctxP: context);
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: selectedTime,
          ),
          readOnly: true,
        ),
      ],
    );
  }

  Future<void> pickTime({ required BuildContext ctxP}) async{
  final TimeOfDay? pickedTime = await showTimePicker(
    context: ctxP,
    initialTime: TimeOfDay.now(),
    barrierDismissible: false,
    confirmText: "Set Time",
    helpText: "Select your task time",
    initialEntryMode: TimePickerEntryMode.input,
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: Center(
          child: SingleChildScrollView(
            child: child!,
          ),
        ),
      );
    },
  );

  if (pickedTime != null && ctxP.mounted) {
 final String formattedTime = MaterialLocalizations.of(ctxP).formatTimeOfDay(
      pickedTime,
    );    
    onTimeSelected(formattedTime);
  }

  }



}
