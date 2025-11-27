import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_riverpod/models/app_state.dart';
import 'package:todo_riverpod/models/task.dart';
import 'package:todo_riverpod/provider/app_state_notifier.dart';
import 'package:todo_riverpod/provider/sqflite_task_storage.dart';
import 'package:todo_riverpod/services/setting_storage.dart';

final sqfliteTaskStorageProvider = Provider<SqfliteTaskStorage>((ref) {
  return SqfliteTaskStorage();
});

final settingsStorageProvider = Provider<Settingstorage>((ref) {
  return Settingstorage();
});

final initialSqfliteTasksProvider = FutureProvider<List<Task>>((ref) {
  final storage = ref.read(sqfliteTaskStorageProvider);
  return storage.loadTasks();
});

class LocalSqfliteNotifier extends AppStateNotifier {
  @override
  Appstate build() {
    // Beobachte den FutureProvider. Riverpod wird den Notifier neu erstellen, wenn sich der Zustand ändert.
    final initialTasksAsyncValue = ref.watch(initialSqfliteTasksProvider);

    _loadSettings();
    // Verwende .when, um alle Zustände des Ladevorgangs explizit zu behandeln.
    return initialTasksAsyncValue.when(
      data: (tasks) => Appstate(
        tasks: tasks,
        isDarkMode: false,
      ), // Wenn Daten da sind, nutze sie.
      loading: () => Appstate(
        tasks: [],
        isDarkMode: false,
      ), // Während des Ladens, starte mit einer leeren Liste.
      error: (err, stack) => Appstate(
        tasks: [],
        isDarkMode: false,
      ), // Im Fehlerfall, starte ebenfalls mit einer leeren Liste.
    );
  }

  Future<void> _loadSettings() async {
    final storage = ref.read(settingsStorageProvider);
    final isDarkMode = await storage.loadSettings();
    state = state.copyWith(isDarkMode: isDarkMode);
  }

  @override
  Future<Task?> addTask(Task task) async {
    final storage = ref.read(sqfliteTaskStorageProvider);
    await storage.saveTask(
      task,
    ); // Speichere die Aufgabe über den Service in der DB
    state = state.copyWith(tasks: [...state.tasks, task]);
    return task;
  }

  @override
  Future<int?> deleteTask(Task task) async {
    final storage = ref.read(sqfliteTaskStorageProvider);
    final count = await storage.deleteTask(task.id);
    final newTasks = state.tasks.where((t) => t.id != task.id).toList();
    state = state.copyWith(tasks: newTasks);
    return count;
  }

  @override
  Future<int?> deletedtoggledtasks() async {
    final storage = ref.read(sqfliteTaskStorageProvider);
    final count = await storage.deleteCompletedTasks();
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
    final storage = ref.read(sqfliteTaskStorageProvider);
    final task = state.tasks.firstWhere((t) => t.id == id);
    final newCompletedStatus = !task.completed;
    await storage.updateTaskCompletion(id, newCompletedStatus);
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
