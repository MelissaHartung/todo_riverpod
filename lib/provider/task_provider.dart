import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/models/task.dart';
import 'package:todo_riverpod/services/storage_json.dart';

final taskProvider = NotifierProvider<TaskNotifier, List<Task>>(
  TaskNotifier.new,
); //global damit überall verfügbar
final taskStorageProvider = Provider<TaskStorage>((ref) {
  return TaskStorage();
}); //stellt eine einzelne instanz von TaskStorage zur verfügung

class TaskNotifier extends Notifier<List<Task>> {
  //verwatltet daten vom typ List<Task>
  @override
  List<Task> build() {
    _loadTasksFromStorage();
    return [];
  }

  void _loadTasksFromStorage() async {
    final storage = ref.read(taskStorageProvider);
    final tasks = await storage.loadTasks();
    state = tasks;
  }

  void addTask(Task task) {
    state = [...state, task];
    ref.read(taskStorageProvider).saveTasks(state);
  } // kopiert den aktuellen state und fügt task hinzu

  void toggleTaskCompletion(String id) {
    state = state.map((task) {
      if (task.id == id) {
        return Task(id: task.id, title: task.title, completed: !task.completed);
      } else {
        return task;
      }
    }).toList();
    ref.read(taskStorageProvider).saveTasks(state);
  }

  void removeTask(String id) {
    state = state.where((task) => task.id != id).toList();
    ref.read(taskStorageProvider).saveTasks(state);
  } // behalten nur die tasks deren id nicht der übergebenen id entspricht
}
