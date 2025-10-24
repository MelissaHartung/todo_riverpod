import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/models/app_state.dart';
import 'package:todo_riverpod/models/task.dart';
import 'package:todo_riverpod/services/storage_json.dart';

final appStateProvider = NotifierProvider<AppStateNotifier, Appstate>(
  AppStateNotifier.new,
);

final taskStorageProvider = Provider<TaskStorage>((ref) {
  return TaskStorage();
});

class AppStateNotifier extends Notifier<Appstate> {
  @override
  Appstate build() {
    _loadTasksFromStorage();
    return Appstate(tasks: [], isDarkMode: false);
  }

  void _loadTasksFromStorage() async {
    final storage = ref.read(
      taskStorageProvider,
    ); // er holt über den provider die instanz von TaskStorage
    final tasks = await storage.loadTasks();
    state = Appstate(tasks: tasks, isDarkMode: state.isDarkMode);
  }

  void addTask(Task task) {
    state = state.copyWith(tasks: [...state.tasks, task]);
    ref.read(taskStorageProvider).saveTasks(state.tasks);
  }

  void toggleTaskCompletion(String id) {
    final newTasks = state.tasks.map((task) {
      if (task.id == id) {
        return task.copyWith(completed: !task.completed);
      }
      return task;
    }).toList();
    state = state.copyWith(tasks: newTasks);
    ref.read(taskStorageProvider).saveTasks(state.tasks);
  }

  void removeTask(String id) {
    final newTasks = state.tasks.where((task) => task.id != id).toList();
    state = state.copyWith(tasks: newTasks);
    ref.read(taskStorageProvider).saveTasks(state.tasks);
  } // behalten nur die tasks deren id nicht der übergebenen id entspricht

  void isDarkMode(bool isDarkMode) {
    state = state.copyWith(isDarkMode: isDarkMode);
  }
  void deletedtoggledtasks () {
    final newTasks = state.tasks.where((task) => !task.completed).toList();
    state =state.copyWith(tasks: newTasks);
    ref.read(taskStorageProvider).saveTasks(state.tasks);
  }
}
