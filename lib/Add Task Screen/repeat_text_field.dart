import 'package:flutter/material.dart';
import 'package:todo/Logic/my_task_options.dart';

class RepeatTextField extends StatelessWidget {
   RepeatTextField({
    super.key,
    required this.selectedRepeat, required this.onSelectedRepeat,
  });

  final MyTaskOptions myTaskOptions = MyTaskOptions();
  final String selectedRepeat;
  final void Function(String?) onSelectedRepeat;


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        suffixIcon: DropdownButton(
          borderRadius: BorderRadius.circular(30),
          dropdownColor: theme.colorScheme.primaryContainer,
          underline: const SizedBox.shrink(),
          items: myTaskOptions.repeats
              .map<DropdownMenuItem<String>>(
                (String ele) => DropdownMenuItem(
                  value: ele,
                  child: Text(ele),
                ),
              )
              .toList(),
          onChanged: onSelectedRepeat,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 30,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        hintText: selectedRepeat,
        hintStyle: const TextStyle(overflow: TextOverflow.visible),

      ),
      readOnly: true,
    );
  }
}
