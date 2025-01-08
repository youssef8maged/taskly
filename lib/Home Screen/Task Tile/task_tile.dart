import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/Logic/my_task_options.dart';
import 'package:todo/Home%20Screen/Task%20Tile/sheet_content.dart';
import 'package:todo/Modules/task.dart';

class TaskTile extends StatefulWidget {
  final Task task;

  const TaskTile({
    super.key,
    required this.task,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.bounceOut),
    );
    // Methods().showOutput("TaskTile ${widget.task.id} initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Methods().showOutput("TaskTile ${widget.task.id} didChangeDependencies");
  }

  @override
  void didUpdateWidget(covariant TaskTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Methods().showOutput("TaskTile ${widget.task.id} didUpdateWidget");
  }

  @override
  void deactivate() {
    super.deactivate();
    // Methods().showOutput("TaskTile ${widget.task.id} deactivate");
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
    // Methods().showOutput("TaskTile ${widget.task.id} dispose");
  }

  @override
  Widget build(BuildContext contextBuild) {
    final ThemeData theme = Theme.of(contextBuild);
    final MediaQueryData mediaQuery = MediaQuery.of(contextBuild);
    final double width = mediaQuery.size.width;
    final Orientation orientation = mediaQuery.orientation;
    animationController.forward();
    return ScaleTransition(
      scale: scaleAnimation,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8, right: 8),
            width: orientation == Orientation.landscape ? width * 0.7 : width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: MyTaskOptions()
                  .colors[widget.task.colorID]!
                  .withValues(alpha: 0.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.text_format,),
                              const SizedBox(width: 8),
                              Text(
                                widget.task.title,
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "(${widget.task.repeat == "None" ? "Once" : widget.task.repeat})",
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           const Icon(Icons.access_time,),
                          const SizedBox(width: 8),
                          Text(widget.task.time),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.description,),
                          const SizedBox(width: 8),
                          Text(
                            widget.task.note,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 150,
                  width: 2,
                  color: Colors.grey,
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    widget.task.isCompleted == 1 ? 'Completed' : 'TO DO',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onLongPress: () => showCustomSheet(contextBuild),
                highlightColor:
                    theme.colorScheme.primary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCustomSheet(BuildContext contextSheet) async {
    final ThemeData theme = Theme.of(contextSheet);
    await Get.bottomSheet<String>(
      SheetContent(
        task: widget.task,
        animationController: animationController,
      ),
      backgroundColor: theme.colorScheme.secondary,
      enterBottomSheetDuration: const Duration(milliseconds: 250),
      exitBottomSheetDuration: const Duration(milliseconds: 250),
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(64)),
      ),
    );
  }
}
