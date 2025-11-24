import 'package:todo_riverpod/models/app_state.dart';
import 'package:todo_riverpod/models/task.dart';
import 'package:todo_riverpod/provider/app_state_notifier.dart';

class LocalSqliteNotifier extends AppStateNotifier {
  @override
  Appstate build() {
    return Appstate(tasks: [], isDarkMode: false);
  }

  @override
  Future<Task?> addTask(Task task) {
    // TODO: implement addTask
    throw UnimplementedError();
  }

  @override
  Future<int?> deleteTask(Task id) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<int?> deletedtoggledtasks() {
    // TODO: implement deletedtoggledtasks
    throw UnimplementedError();
  }

  @override
  Future<bool?> isDarkMode(bool isDarkMode) {
    // TODO: implement isDarkMode
    throw UnimplementedError();
  }

  @override
  Future<bool?> toggleTaskCompletion(String id) {
    // TODO: implement toggleTaskCompletion
    throw UnimplementedError();
  }
}
