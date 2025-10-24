import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:todo_riverpod/models/task.dart';
import 'package:todo_riverpod/provider/app_state_notifier.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AddToDoScreen extends ConsumerStatefulWidget {
  const AddToDoScreen({super.key});

  @override
  ConsumerState<AddToDoScreen> createState() => _AddToDoScreenState();
}

class _AddToDoScreenState extends ConsumerState<AddToDoScreen> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  
        
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Aufgabe eingeben',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 100, 100, 100)),
                  border: InputBorder.none,
                ),
              ),
            ),

            // Divider(color: Colors.grey[700]),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).cardColor,
              ),
              onPressed: () {
                final title = _titleController.text;
                if (title.isNotEmpty) {
                  final newTask = Task(
                    id: uuid.v4(),
                    title: title,
                    // Benutze die ausgewählte Zeit oder die aktuelle
                  );
                  ref.read(appStateProvider.notifier).addTask(newTask);
                  Navigator.pop(context);
                }
              },
              child: const Text('speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
