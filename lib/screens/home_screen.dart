import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:todo_riverpod/provider/app_state_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(appStateProvider).tasks;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Center(
                    child: Text(
                      'To Do Liste',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    icon: const Icon(Icons.settings),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          color: task.completed
                              ? const Color.fromARGB(255, 87, 87, 87)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Aufgabe löschen?'),
                              content: const Text(
                                'Soll diese Aufgabe wirklich gelöscht werden?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Abbrechen'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(appStateProvider.notifier)
                                        .removeTask(task.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Löschen'),
                                ),
                              ],
                            );
                          },
                        );
                      },

                      trailing: Checkbox(
                        value: task.completed,
                        onChanged: (bool? newValue) {
                          ref
                              .read(appStateProvider.notifier)
                              .toggleTaskCompletion(task.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 40.0,
                right: 15.0,
              ), // Fügt einen Abstand auf allen Seiten hinzu
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 212, 73, 189),
                onPressed: () {
                  Navigator.pushNamed(context, '/add');
                },
                child: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
