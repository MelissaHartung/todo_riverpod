import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_riverpod/models/task.dart';

class SqfliteTaskStorage {
  Database? _db;

  Future<Database> _getDb() async {
    if (_db != null) {
      return _db!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            title TEXT,
            completed INTEGER
          )
        ''');
      },
    );
    return _db!;
  }

  Future<List<Task>> loadTasks() async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return maps.map((map) {
      return Task.fromJson({...map, 'completed': map['completed'] == 1});
    }).toList();
  }

  Future<void> saveTask(Task task) async {
    final db = await _getDb();
    final taskMap = task.toJson();
    taskMap['completed'] = task.completed ? 1 : 0;
    await db.insert(
      'tasks',
      taskMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTaskCompletion(String id, bool completed) async {
    final db = await _getDb();
    await db.update(
      'tasks',
      {'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(String id) async {
    final db = await _getDb();
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCompletedTasks() async {
    final db = await _getDb();
    return await db.delete('tasks', where: 'completed = ?', whereArgs: [1]);
  }
}
