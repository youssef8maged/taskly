import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Methods {

  Methods._privateConstructor();
  static final Methods _instance = Methods._privateConstructor();
  factory Methods() => _instance;

  void showScaffold(BuildContext contextP, String contentP) {
    ScaffoldMessenger.of(contextP).clearSnackBars();
    ScaffoldMessenger.of(contextP).showSnackBar(
      SnackBar(
        content: Text(contentP),
      ),
    );
  }

  void showOutput(String? contentP, [int lengthP = 800]) {
    if (kDebugMode) {
      debugPrint("\n  $contentP\n", wrapWidth: lengthP);
    }
  }
}
