
import 'package:flutter/material.dart';
import 'package:todo/Helpers/methods.dart';

class Boundary extends StatelessWidget {
  final Widget child;
  const Boundary({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Methods().showOutput("MyBoundary built");
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.blue,
      child: child,
    );
  }
}