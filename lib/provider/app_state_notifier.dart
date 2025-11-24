import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/models/app_state.dart';
import 'package:todo_riverpod/models/task.dart';
import 'package:todo_riverpod/provider/local_json_notifier.dart';
import 'package:todo_riverpod/provider/local_sqlite.dart';
import 'package:todo_riverpod/services/storage_json.dart';
import 'package:todo_riverpod/services/setting_storage.dart';

final appStateProvider = NotifierProvider<AppStateNotifier, Appstate>(() {
  return LocalSqliteNotifier();
});

final taskStorageProvider = Provider<TaskStorage>((ref) {
  return TaskStorage();
});
final settingsStorageProvider = Provider<Settingstorage>((ref) {
  return Settingstorage();
});

abstract class AppStateNotifier extends Notifier<Appstate> {
  Future<Task?> addTask(Task task);
  Future<bool?> toggleTaskCompletion(String id);

  Future<int?> deleteTask(Task id);
  Future<bool?> isDarkMode(bool isDarkMode);

  Future<int?> deletedtoggledtasks();
}
