import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTextField extends StatelessWidget {
  const DateTextField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final void Function(DateTime) onDateSelected;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: const Icon(Icons.date_range),
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
              confirmText: "Set Date",
              barrierDismissible: false,
              helpText: "Select your task date",
              fieldLabelText: "Enter your date",
              initialEntryMode: DatePickerEntryMode.input,
              builder: (BuildContext context, Widget? child) {
      return Center(
        child: SingleChildScrollView(
          child: child!,
        ),
      );
    },
            );

            if (pickedDate != null) {
              onDateSelected(pickedDate);
            }
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        hintText: DateFormat('dd/MM/yyyy').format(selectedDate),
      ),
      readOnly: true,
    );
  }
}
