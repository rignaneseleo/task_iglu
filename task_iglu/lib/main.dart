import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_iglu/features/tasks/providers/task_provider.dart';
import 'package:task_iglu/features/tasks/repositories/sp_task_repository.dart';
import 'package:task_iglu/features/tasks/repositories/task_repository.dart';
import 'package:task_iglu/features/tasks/views/pages/tasks_list_page.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences instance for local storage
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        // Provide TaskRepository implementation using SharedPreferences
        Provider<TaskRepository>(
          create: (_) => SpTaskRepository(sharedPreferences),
        ),
        // Provide TaskProvider that depends on TaskRepository
        // Updates if TaskRepository changes
        ChangeNotifierProxyProvider<TaskRepository, TaskProvider>(
          create: (context) => TaskProvider(
            context.read<TaskRepository>(),
          ),
          update: (context, repository, previous) => TaskProvider(repository),
        ),
      ],
      child: const TaskApp(),
    ),
  );
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TaskListPage(),
    );
  }
}
