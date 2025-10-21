import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path; // Um Pfade sauber zusammenzusetzen
import 'package:path_provider/path_provider.dart';
import 'package:todo_riverpod/models/task.dart';

class TaskStorage {
  Future<File> _getLocalFile() async {
    // methode, um den privaten Dateipfad zu bekommen für die app
    final directory =
        await getApplicationDocumentsDirectory(); // Holt das Verzeichnis für Anwendungsdokumente
    return File(
      path.join(directory.path, 'tasks.json'),
    ); // Erstellt den vollständigen Pfad zur Datei als file-objekt
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final file = await _getLocalFile(); // Holt die Datei
    final List<Map<String, dynamic>> jsonList = tasks
        .map((task) => task.toJson())
        .toList(); // Konvertiere jede Aufgabe in eine JSON-Map
    final jsonString = jsonEncode(
      jsonList,
    ); // Konvertiere die Liste von Maps in einen JSON-String
    await file.writeAsString(
      jsonString,
    ); // Schreibe den JSON-String in die Datei
  }

  Future<List<Task>> loadTasks() async {
    final file = await _getLocalFile(); // Holt die Datei
    if (await file.exists()) {
      final jsonString = await file
          .readAsString(); // Liest den JSON-String aus der Datei
      final List<dynamic> jsonList = jsonDecode(
        jsonString,
      ); // Dekodiert den JSON-String in eine Liste von dynamischen Objekten
      return jsonList
          .map((json) => Task.fromJson(json))
          .toList(); // Konvertiere jede JSON-Map zurück in ein Task-Objekt
    } else {
      return []; // Wenn die Datei nicht existiert, gib eine leere Liste zurück
    }
  }
}
