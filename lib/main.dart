import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/provider/app_state_notifier.dart';
import 'package:todo_riverpod/screens/add_to_do.dart';
import 'package:todo_riverpod/screens/home_screen.dart';
import 'package:todo_riverpod/screens/settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      // ProviderScope umschließt deine App
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appStateProvider).isDarkMode;
    return MaterialApp(
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        cardColor: const Color.fromARGB(255, 40, 40, 40),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        cardColor: const Color.fromARGB(255, 216, 199, 215),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      home: const HomeScreen(),
      routes: {
        '/add': (context) => AddToDoScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
