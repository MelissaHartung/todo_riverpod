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

final initialSettingsProvider = FutureProvider<bool>((ref) {
  final storage = ref.read(settingsStorageProvider);
  return storage.loadSettings();
});

class LocalSqfliteNotifier extends AppStateNotifier {
  @override
  Appstate build() {
    final tasksAsync = ref.watch(initialSqfliteTasksProvider);
    final isDarkModeAsync = ref.watch(initialSettingsProvider);

    if (tasksAsync.isLoading || isDarkModeAsync.isLoading) {
      return Appstate(tasks: [], isDarkMode: false);
    }
    return Appstate(
      tasks: tasksAsync.value ?? [],
      isDarkMode: isDarkModeAsync.value ?? false,
    );
  }

  @override
  Future<Task?> addTask(Task task) async {
    final storage = ref.read(sqfliteTaskStorageProvider);
    await storage.saveTask(task);
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
