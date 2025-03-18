import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/project.dart';
import '../../providers/project_provider.dart';
import '../../widgets/task_dialog.dart';
import '../../constants/app_theme.dart';

class ProjectPage extends StatelessWidget {
  final Project project;

  const ProjectPage({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTaskDialog(context),
          ),
        ],
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          final updatedProject = projectProvider.projects
              .firstWhere((p) => p.id == project.id, orElse: () => project);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProjectHeader(updatedProject),
                const SizedBox(height: 24),
                _buildTaskList(context, updatedProject),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectHeader(Project project) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: AppTheme.titleStyle,
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 85,
                        height: 85,
                        child: CircularProgressIndicator(
                          value: project.progress,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(project.color),
                        ),
                      ),
                      Text(
                        '${(project.progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: project.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              project.description,
              style: AppTheme.bodyStyle,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: project.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    project.status.toString().split('.').last,
                    style: TextStyle(
                      color: project.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${project.tasks.where((task) => task.isCompleted).length}/${project.tasks.length} Tasks Completed',
                  style: AppTheme.bodyStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, Project project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tasks',
          style: AppTheme.subtitleStyle,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: project.tasks.length,
          itemBuilder: (context, index) {
            final task = project.tasks[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (bool? value) {
                    if (value != null) {
                      context
                          .read<ProjectProvider>()
                          .toggleTaskCompletion(project.id, task.id);
                    }
                  },
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted ? Colors.grey : AppTheme.textColor,
                  ),
                ),
                subtitle: Text(task.description),
                trailing: Text(
                  task.createdAt.toString().split(' ')[0],
                  style: AppTheme.captionStyle,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    final result = await showDialog<Task>(
      context: context,
      builder: (context) => TaskDialog(project: project),
    );

    if (result != null && context.mounted) {
      context.read<ProjectProvider>().addTask(project.id, result);
    }
  }
}
