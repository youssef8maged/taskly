import 'package:flutter/material.dart';
import 'package:todo/Logic/my_task_options.dart';

class ColorAvatars extends StatelessWidget {
  ColorAvatars({
    super.key,
    required this.selectedColor, required this.onSelectedColor,
  });

  final void Function(Color) onSelectedColor;
  final MyTaskOptions myTaskOptions = MyTaskOptions();
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Wrap(
      children: myTaskOptions.colors.values.map<Widget>((  Color ele) {
        return Padding(
          padding: const EdgeInsets.only(right: 8,bottom: 8),
          child: InkWell(
            onTap: () {
              onSelectedColor(ele);
            },
            borderRadius: BorderRadius.circular(10),
            splashColor: theme.colorScheme.primary,
            child: CircleAvatar(
              backgroundColor: ele,
              radius: 20,
              child: Icon(
                selectedColor == ele ? Icons.check : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
