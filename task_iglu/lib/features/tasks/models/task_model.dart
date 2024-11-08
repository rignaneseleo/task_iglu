import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required int id,
    required String title,
    required String description,
    required bool isCompleted,
  }) = _TaskModel;
  const TaskModel._();

  factory TaskModel.empty() => TaskModel(
        id: DateTime.now().millisecondsSinceEpoch,
        title: '',
        description: '',
        isCompleted: false,
      );

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
