import 'package:task_iglu/features/tasks/models/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getTasks({String? searchQuery});
  Future<TaskModel> getTask(int id);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(int id);
}
