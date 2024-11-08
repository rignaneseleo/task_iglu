import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_iglu/features/tasks/models/task_model.dart';
import 'package:task_iglu/features/tasks/providers/task_provider.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, this.task});

  final TaskModel? task;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late TaskModel task;
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    _initializeTask();
  }

  void _initializeTask() {
    task = widget.task ?? TaskModel.empty();
    titleController = TextEditingController(text: task.title);
    descriptionController = TextEditingController(text: task.description);
  }

  void _onTitleChanged(String value) {
    setState(() {
      task = task.copyWith(title: value);
    });
  }

  void _onDescriptionChanged(String value) {
    setState(() {
      task = task.copyWith(description: value);
    });
  }

  void _handleSave() {
    if (widget.task == null) {
      context.read<TaskProvider>().createTask(task);
    } else {
      context.read<TaskProvider>().updateTask(task);
    }
    Navigator.pop(context);
  }

  void _handleDelete() {
    context.read<TaskProvider>().deleteTask(task.id);
    Navigator.pop(context);
  }

  Widget _buildTitleField() {
    return TextField(
      controller: titleController,
      onChanged: _onTitleChanged,
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: descriptionController,
      onChanged: _onDescriptionChanged,
      decoration: const InputDecoration(
        labelText: 'Description',
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: task.title.trim().isEmpty ? null : _handleSave,
      child: Text(widget.task == null ? 'Create' : 'Update'),
    );
  }

  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: _handleDelete,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
      child: const Text(
        'Delete',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTitleField(),
              const SizedBox(height: 8),
              _buildDescriptionField(),
              const SizedBox(height: 8),
              _buildSaveButton(),
              if (widget.task != null) ...[
                const SizedBox(height: 8),
                _buildDeleteButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
