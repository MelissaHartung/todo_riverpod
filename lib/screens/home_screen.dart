import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:todo_riverpod/provider/app_state_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(appStateProvider).tasks;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('To Do Liste', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
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
                              ? Colors.grey
                              : Theme.of(context).textTheme.bodyMedium?.color,
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                ElevatedButton(onPressed: ref.read(appStateProvider.notifier).deletedtoggledtasks, child: Text('Alle löschen')),
                const Spacer(),

                FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 212, 73, 189),
                  onPressed: () {
                    Navigator.pushNamed(context, '/add');
                  },
                  child: const Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
