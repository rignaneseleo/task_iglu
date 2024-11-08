import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_iglu/features/tasks/models/task_model.dart';
import 'package:task_iglu/features/tasks/providers/task_provider.dart';
import 'package:task_iglu/features/tasks/views/pages/task_page.dart';

class TaskTileWidget extends StatelessWidget {
  const TaskTileWidget(this.task, {super.key});

  final TaskModel task;

  void _onDismissed(BuildContext context) {
    context.read<TaskProvider>().deleteTask(task.id);
  }

  void _onCheckboxChanged(BuildContext context, bool? value) {
    if (value != null) {
      context.read<TaskProvider>().updateTask(
            task.copyWith(isCompleted: value),
          );
    }
  }

  void _onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskPage(task: task),
      ),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      task.title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      task.description,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id.toString()),
      background: _buildDismissibleBackground(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _onDismissed(context),
      child: ListTile(
        title: _buildTitle(context),
        subtitle: _buildSubtitle(context),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (value) => _onCheckboxChanged(context, value),
        ),
        onTap: () => _onTap(context),
      ),
    );
  }
}
