import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoTasks extends StatefulWidget {
  const NoTasks({
    super.key,
  });

  @override
  State<NoTasks> createState() => _NoTasksState();
}

class _NoTasksState extends State<NoTasks> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Methods().showOutput("NoTasks initState");
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 2), // Start off-screen below
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

  }

  @override
  void dispose() {
    // Methods().showOutput("NoTasks dispose");
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: SvgPicture.asset(
              "pics/task.svg",
              fit: BoxFit.fitWidth,
              semanticsLabel: "empty",
              height: 100,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.secondary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SlideTransition(
            position: _slideAnimation,
            child: Text(
              "There is no tasks here!\nAdd tasks to make your days productive",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
