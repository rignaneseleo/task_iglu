import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_iglu/features/tasks/models/task_model.dart';
import 'package:task_iglu/features/tasks/providers/task_provider.dart';
import 'package:task_iglu/features/tasks/views/pages/task_page.dart';
import 'package:task_iglu/features/tasks/views/widgets/task_tile_widget.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String _searchQuery = '';
  bool _showSearch = false;

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchQuery = '';
      }
    });
  }

  void _updateSearchQuery(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  Widget _buildAppBarTitle() {
    return _showSearch
        ? TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Search tasks...',
              border: InputBorder.none,
            ),
            onChanged: _updateSearchQuery,
          )
        : const Text('Tasks');
  }

  Widget _buildTasksList(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks found'));
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) => TaskTileWidget(tasks[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: FutureBuilder<List<TaskModel>>(
        future:
            context.watch<TaskProvider>().getTasks(searchQuery: _searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return _buildTasksList(snapshot.data ?? []);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
