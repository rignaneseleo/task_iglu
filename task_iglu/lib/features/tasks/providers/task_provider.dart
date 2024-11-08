import 'package:flutter/widgets.dart';
import 'package:task_iglu/features/tasks/models/task_model.dart';
import 'package:task_iglu/features/tasks/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider(this._repository);

  final TaskRepository _repository;

  Future<List<TaskModel>> getTasks({String? searchQuery}) =>
      _repository.getTasks(searchQuery: searchQuery);

  Future<TaskModel> getTask(int id) => _repository.getTask(id);

  Future<TaskModel> createTask(TaskModel task) async {
    final newTask = await _repository.createTask(task);
    notifyListeners();
    return newTask;
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final updatedTask = await _repository.updateTask(task);
    notifyListeners();
    return updatedTask;
  }

  Future<void> deleteTask(int id) async {
    await _repository.deleteTask(id);
    notifyListeners();
  }
}
