import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/models/task.dart';


final taskProvider = NotifierProvider<TaskNotifier, List<Task>>(TaskNotifier.new);  //global damit überall verfügbar

class TaskNotifier extends Notifier<List<Task>> { //verwatltet daten vom typ List<Task>
  @override
  List<Task> build() {
    // Gib hier ein paar Test-Aufgaben zurück, um zu sehen, ob sie angezeigt werden.
    return [
      Task(id: '1', title: 'Einkaufen gehen', completed: false),
      Task(id: '2', title: 'Flutter lernen', completed: true),
      Task(id: '3', title: 'Freunde anrufen', completed: false),
    ];
  } //leere liste zu beginn

  void addTask(Task task) {
    state = [...state, task];
  }// kopiert den aktuellen state und fügt task hinzu

  void toggleTaskCompletion(String id) {
    state = state.map((task) {
      if (task.id == id) {
        return Task(id: task.id, title: task.title, completed: !task.completed);
      } else {
        return task;
      }
    }).toList();
  }

  void removeTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }// behalten nur die tasks deren id nicht der übergebenen id entspricht
}