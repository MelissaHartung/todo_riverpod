import 'package:todo_riverpod/models/task.dart';

class Appstate {
  final List<Task> tasks;
  final bool isDarkMode;
  Appstate({required this.tasks, required this.isDarkMode});

  Appstate copyWith({List<Task>? tasks, bool? isDarkMode}) {
    return Appstate(
      tasks: tasks ?? this.tasks,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'isDarkMode': isDarkMode,
    };
  }

  factory Appstate.fromJson(Map<String, dynamic> json) {
    return Appstate(
      tasks: (json['tasks'] as List)
          .map((task) => Task.fromJson(task))
          .toList(),
      isDarkMode: json['isDarkMode'],
    );
  }
}
