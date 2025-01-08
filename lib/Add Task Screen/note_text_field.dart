import 'package:flutter/material.dart';

class NoteTextField extends StatelessWidget {
  const NoteTextField({
    super.key,
    required this.noteController,
  });

  final TextEditingController noteController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      decoration: InputDecoration(
        suffix: const Icon(
          Icons.description,
        ),
        hintText: 'Enter your note...',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      controller: noteController,
    );
  }
}
