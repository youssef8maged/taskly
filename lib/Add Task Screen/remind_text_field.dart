import 'package:flutter/material.dart';
import 'package:todo/Logic/my_task_options.dart';

class RemindTextField extends StatelessWidget {
   RemindTextField({
    super.key,
    required this.selectedReminder, required this.onReminderSelected, 
  });

  final void Function (int?) onReminderSelected;
  final int selectedReminder;
  final MyTaskOptions myTaskOptions = MyTaskOptions();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        suffixIcon: DropdownButton(
          borderRadius: BorderRadius.circular(30),
          dropdownColor: theme.colorScheme.primaryContainer,
          underline: const SizedBox(),
          items: myTaskOptions.reminders
              .map<DropdownMenuItem<int>>(
                (int ele) => DropdownMenuItem(
                  value: ele,
                  child: Text('$ele min'),
                ),
              )
              .toList(),
          onChanged: onReminderSelected,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 30,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        hintText: selectedReminder == 0
            ? 'No reminder'
            : '$selectedReminder minutes before',
      ),
      readOnly: true,
    );
  }
}
