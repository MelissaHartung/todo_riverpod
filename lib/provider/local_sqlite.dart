import 'package:sqflite/sqflite.dart';
import 'package:todo_riverpod/models/app_state.dart';
import 'package:todo_riverpod/models/task.dart';
import 'package:todo_riverpod/provider/app_state_notifier.dart';
import 'package:path/path.dart';

class LocalSqliteNotifier extends AppStateNotifier {
  Database? _db;

  Future<Database> _getDb() async {
    // Überprüfen, ob die Datenbank bereits geöffnet ist
    if (_db != null) {
      return _db!;
    }

    final dbPath = await getDatabasesPath();
    // Erstellen des vollständigen Pfads zur Datenbankdatei
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

  @override
  Appstate build() {
    _loadTasks();
    _loadSettings();
    return Appstate(tasks: [], isDarkMode: false);
  }

  Future<void> _loadSettings() async {
    final storage = ref.read(settingsStorageProvider);
    final isDarkMode = await storage.loadSettings();
    state = state.copyWith(isDarkMode: isDarkMode);
  }

  Future<void> _loadTasks() async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    // Gibt uns alle Zeilen der Tabelle 'tasks' zurück und wandelt sie in Task-Objekte um mit SELECT * FROM
    final tasks = maps.map((map) {
      return Task.fromJson({...map, 'completed': map['completed'] == 1});
      // Wir fügen eine neue Map hinzu, in der wir den 'completed'-Wert anpassen, da kein Boolean in der DB gespeichert werden kann.
    }).toList();
    state = state.copyWith(tasks: tasks);
  }

  @override
  Future<Task?> addTask(Task task) async {
    final db = await _getDb(); // Holt die Datenbankverbindung
    final taskMap = task.toJson();
    taskMap['completed'] = task.completed
        ? 1
        : 0; // Konvertiere Boolean zu Integer
    await db.insert(
      'tasks',
      taskMap,
    ); // Fügt die neue Aufgabe in die Tabelle 'tasks' ein
    state = state.copyWith(tasks: [...state.tasks, task]);
    return task;
  }

  @override
  Future<int?> deleteTask(Task task) async {
    final db = await _getDb();
    final count = await db.delete(
      'tasks',
      where:
          'id = ?', // Das '?' ist ein Platzhalter, um SQL-Injection zu verhindern.
      whereArgs: [task.id], // Hier wird der Wert für den Platzhalter übergeben.
    );
    // Aktualisiere den lokalen Zustand, indem du eine neue Liste ohne die gelöschte Aufgabe erstellst.
    final newTasks = state.tasks.where((t) => t.id != task.id).toList();
    state = state.copyWith(tasks: newTasks);
    return count;
  }

  @override
  Future<int?> deletedtoggledtasks() async {
    final db = await _getDb();
    final count = await db.delete(
      'tasks',
      where: 'completed = ?',
      whereArgs: [1],
    );
    final newTasks = state.tasks.where((task) => !task.completed).toList();
    state = state.copyWith(tasks: newTasks);
    return count;
  }

  @override
  Future<bool?> isDarkMode(bool isDarkMode) async {
    await ref.read(settingsStorageProvider).saveSettings(isDarkMode);
    state = state.copyWith(isDarkMode: isDarkMode);
    return isDarkMode;
  }

  @override
  Future<bool?> toggleTaskCompletion(String id) async {
    final db = await _getDb();
    final task = state.tasks.firstWhere((t) => t.id == id);
    final newCompletedStatus = !task.completed;
    await db.update(
      'tasks',
      {'completed': newCompletedStatus ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    final newTasks = state.tasks.map((t) {
      if (t.id == id) {
        return t.copyWith(completed: newCompletedStatus);
      }
      return t;
    }).toList();
    state = state.copyWith(tasks: newTasks);
    return null;
  }
}
