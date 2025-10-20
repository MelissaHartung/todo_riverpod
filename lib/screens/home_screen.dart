import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:todo_riverpod/provider/task_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column( 
        children: [
        
          Padding(
            padding: const EdgeInsets.all(8.0), 
            child: Container(
              height: 80, 
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black, 
                borderRadius: BorderRadius.circular(15), 
              ),
              child: const Center(
                child: Text(
                  'To Do Liste', 
                  style: TextStyle(color: Colors.white, fontSize: 18),
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
                  color: const Color.fromARGB(255, 31, 30, 30), 
                  borderRadius: BorderRadius.circular(20), 
                ),
                // 2. Wir benutzen ListView.builder, um die Liste effizient darzustellen.
                child: ListView.builder(
                  itemCount: tasks.length, // Wie viele Einträge gibt es?
                  itemBuilder: (context, index) {
                    // Hol dir die spezifische Aufgabe für diese Zeile.
                    final task = tasks[index];
                    // Baue ein ListTile für diese Aufgabe.
                    return ListTile(
                      title: Text(
                        task.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Checkbox(
                        value: task.completed,
                        onChanged: (bool? newValue) {
                          // Sage dem Notifier, dass er den Status dieser einen Aufgabe umschalten soll.
                          ref.read(taskProvider.notifier).toggleTaskCompletion(task.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
