import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:todo_riverpod/provider/app_state_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appStateProvider).isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SwitchListTile(
        title: const Text('Darkmode'),
        value: isDarkMode,
        onChanged: (value) {
          ref.read(appStateProvider.notifier).isDarkMode(value);
        },
      ),
    );
  }
}
