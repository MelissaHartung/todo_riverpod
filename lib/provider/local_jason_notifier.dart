import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/models/app_state.dart';
import 'package:todo_riverpod/models/task.dart';
import 'package:todo_riverpod/provider/app_state_notifier.dart';
import 'package:todo_riverpod/services/storage_json.dart';
import 'package:todo_riverpod/services/setting_storage.dart';

final appStateProvider = NotifierProvider<LocalJsonNotifier, Appstate>(
  LocalJsonNotifier.new,
);

final taskStorageProvider = Provider<TaskStorage>((ref) {
  return TaskStorage();
});
final settingsStorageProvider = Provider<Settingstorage>((ref) {
  return Settingstorage();
});

class LocalJsonNotifier extends AppStateNotifier {
  @override
  Appstate build() {
    _loadTasksFromStorage();
    _loadSettingsFromStorage();
    return Appstate(tasks: [], isDarkMode: false);
  }

  Future<void> _loadSettingsFromStorage() async {
    final storage = ref.read(settingsStorageProvider);
    final isDarkMode = await storage.loadSettings();
    state = state.copyWith(isDarkMode: isDarkMode);
  }

  void _loadTasksFromStorage() async {
    final storage = ref.read(
      taskStorageProvider,
    ); // er holt über den provider die instanz von TaskStorage
    final tasks = await storage.loadTasks();
    state = state.copyWith(tasks: tasks);
  }

  @override
  Future<Task?> addTask(Task task) async {
    state = state.copyWith(tasks: [...state.tasks, task]);
    await _save();
    return task;
  }

  @override
  Future<bool?> toggleTaskCompletion(String id) async {
    final newTasks = state.tasks.map((task) {
      if (task.id == id) {
        return task.copyWith(completed: !task.completed);
      }
      return task;
    }).toList();
    state = state.copyWith(tasks: newTasks);
    await _save();
    return Future.value(null);
  }

  @override
  Future<int?> deleteTask(Task task) async {
    final newTasks = state.tasks.where((t) => t.id != task.id).toList();
    state = state.copyWith(tasks: newTasks);
    await _save();
    return Future.value(newTasks.length);
  } // behalten nur die tasks deren id nicht der übergebenen id entspricht

  @override
  Future<bool> isDarkMode(bool isDarkMode) async {
    state = state.copyWith(isDarkMode: isDarkMode);
    await _save();
    return isDarkMode;
  }

  @override
  Future<int?> deletedtoggledtasks() async {
    final oldLength = state.tasks.length;
    final newTasks = state.tasks.where((task) => !task.completed).toList();
    final newLength = newTasks.length;
    state = state.copyWith(tasks: newTasks);
    await _save();
    return oldLength - newLength;
  }

  Future<void> _save() async {
    await ref.read(taskStorageProvider).saveTasks(state.tasks);
  }
}
