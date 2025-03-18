import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

class TodoListPage extends StatefulWidget {
  final String title;
  static int inProgressTasks = 3;
  static int completedTasks = 5;

  const TodoListPage({super.key, required this.title});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Complete project documentation',
      'isCompleted': false,
      'dueDate': DateTime.now().add(const Duration(days: 2)),
    },
    {
      'title': 'Review code changes',
      'isCompleted': false,
      'dueDate': DateTime.now().add(const Duration(days: 1)),
    },
    {
      'title': 'Update dependencies',
      'isCompleted': true,
      'dueDate': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'title': 'Fix bug in login screen',
      'isCompleted': true,
      'dueDate': DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Checkbox(
                value: task['isCompleted'],
                onChanged: (value) {
                  setState(() {
                    task['isCompleted'] = value;
                    _updateTaskCounts();
                  });
                },
              ),
              title: Text(
                task['title'],
                style: TextStyle(
                  decoration:
                      task['isCompleted'] ? TextDecoration.lineThrough : null,
                  color: task['isCompleted'] ? Colors.grey : null,
                ),
              ),
              subtitle: Text(
                'Due: ${task['dueDate'].toString().substring(0, 10)}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Edit task
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _tasks.removeAt(index);
                        _updateTaskCounts();
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show add task dialog
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _updateTaskCounts() {
    setState(() {
      TodoListPage.inProgressTasks =
          _tasks.where((task) => !task['isCompleted']).length;
      TodoListPage.completedTasks =
          _tasks.where((task) => task['isCompleted']).length;
    });
  }
}
