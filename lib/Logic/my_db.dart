import 'package:sqflite/sqflite.dart';
import 'package:todo/Helpers/methods.dart';
import 'package:todo/Modules/task.dart';

class MyDb {
  Database? db;

  MyDb._privateConstructor();
  static final MyDb _instance = MyDb._privateConstructor();
  factory MyDb() => _instance;



  
  Future<void> initDB() async {
    if (db != null) {
      return;
    }
    String path = '${await getDatabasesPath()}tasks.db';
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database dbP, int ver) async {
        await dbP.execute(
          "CREATE TABLE tasks("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "task BLOB"
          ")",
        );
      },
    );
    Methods().showOutput("DB Inizialized at $path");
  }


  Future<int> insertTask(Task task) async {
    return await db!.insert(
      'tasks',
      {'task': task.toUint8List()},
    );
  }

  Future<int> updateTask(Task task) async {
    return await db!.update(
      'tasks',
      {'task': task.toUint8List()},
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(Task task) async {
    return await db!.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<List<Map<String, Object?>>> getTasks() async {
    return await db!.query('tasks');
  }

}
