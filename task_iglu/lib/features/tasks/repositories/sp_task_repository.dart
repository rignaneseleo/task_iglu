import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_iglu/features/tasks/models/task_model.dart';
import 'package:task_iglu/features/tasks/repositories/task_repository.dart';

const kTasksKey = 'tasks';

class SpTaskRepository implements TaskRepository {
  SpTaskRepository(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    final prefs = sharedPreferences;
    final tasks = await getTasks();
    tasks.add(task);
    await prefs.setStringList(
      kTasksKey,
      tasks.map((t) => jsonEncode(t.toJson())).toList(),
    );
    return task;
  }

  @override
  Future<void> deleteTask(int id) async {
    final prefs = sharedPreferences;
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == id);
    await prefs.setStringList(
      kTasksKey,
      tasks.map((t) => jsonEncode(t.toJson())).toList(),
    );
  }

  @override
  Future<TaskModel> getTask(int id) async {
    final tasks = await getTasks();
    final task = tasks.firstWhere((t) => t.id == id);
    return task;
  }

  @override
  Future<List<TaskModel>> getTasks({String? searchQuery}) async {
    final prefs = sharedPreferences;
    final tasksString = prefs.getStringList(kTasksKey) ?? [];
    var tasksList = tasksString
        .map(
          (str) => TaskModel.fromJson(jsonDecode(str) as Map<String, dynamic>),
        )
        .toList();

    if (searchQuery != null) {
      tasksList = tasksList
          .where(
            (t) => t.title.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    return tasksList;
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final prefs = sharedPreferences;
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    tasks[index] = task;
    await prefs.setStringList(
      kTasksKey,
      tasks.map((t) => jsonEncode(t.toJson())).toList(),
    );
    return task;
  }
}
