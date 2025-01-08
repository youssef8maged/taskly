import 'dart:convert';
import 'dart:typed_data';

class Task {
  final int id;
  final String title;
  final String note;
  int isCompleted;
  final String date;
  final String time;
  final int colorID;
  final int remind;
  final String repeat;

  Task({
    required this.id,
    required this.title,
    required this.note,
    required this.isCompleted,
    required this.date,
    required this.time,
    required this.colorID,
    required this.remind,
    required this.repeat,
  });

  Uint8List toUint8List() {
    final Map<String, dynamic> taskMap = {
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'time': time,
      'colorID': colorID,
      'remind': remind,
      'repeat': repeat,
    };
    final String taskJson = jsonEncode(taskMap);
    return Uint8List.fromList(utf8.encode(taskJson));
  }

  factory Task.fromUint8List(
      int idP,
      Uint8List data) {
    final String taskJson = utf8.decode(data);
    final dynamic taskMap = jsonDecode(taskJson);
    return Task(
      id: idP,
      title: taskMap['title'] as String,
      note: taskMap['note'] as String,
      isCompleted: taskMap['isCompleted'] as int,
      date: taskMap['date'] as String,
      time: taskMap['time'] as String,
      colorID: taskMap['colorID'] as int,
      remind: taskMap['remind'] as int,
      repeat: taskMap['repeat'] as String,
    );
  }
}
