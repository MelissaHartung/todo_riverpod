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
}
