import 'package:flutter/foundation.dart';
import '../models/project.dart';
import '../services/project_service.dart';
import 'package:flutter/material.dart';

class ProjectProvider with ChangeNotifier {
  final ProjectService _projectService;
  List<Project> _projects = [];
  final bool _isLoading = false;

  ProjectProvider() : _projectService = ProjectService();

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;

  Future<void> loadProjects() async {
    // TODO: Implement actual API call when backend is ready
    _projects = [
      Project(
        id: '1',
        name: 'Making History',
        description: 'A historical documentation app',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        color: Colors.green,
        tasks: [
          Task(
            id: '1',
            title: 'Research Phase',
            description: 'Conduct initial research',
            isCompleted: true,
            createdAt: DateTime.now().subtract(const Duration(days: 25)),
          ),
          Task(
            id: '2',
            title: 'Design Phase',
            description: 'Create UI/UX design',
            isCompleted: true,
            createdAt: DateTime.now().subtract(const Duration(days: 20)),
          ),
          Task(
            id: '3',
            title: 'Development Phase',
            description: 'Implement core features',
            isCompleted: false,
            createdAt: DateTime.now().subtract(const Duration(days: 15)),
          ),
        ],
      ),
      Project(
        id: '2',
        name: 'Medical App',
        description: 'Healthcare management system',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(days: 45)),
        color: Colors.blue,
        tasks: [
          Task(
            id: '4',
            title: 'Requirements Analysis',
            description: 'Gather user requirements',
            isCompleted: true,
            createdAt: DateTime.now().subtract(const Duration(days: 40)),
          ),
          Task(
            id: '5',
            title: 'System Design',
            description: 'Design system architecture',
            isCompleted: false,
            createdAt: DateTime.now().subtract(const Duration(days: 35)),
          ),
        ],
      ),
    ];
    notifyListeners();
  }

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void updateProject(Project project) {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      notifyListeners();
    }
  }

  void deleteProject(String projectId) {
    _projects.removeWhere((project) => project.id == projectId);
    notifyListeners();
  }

  void addTask(String projectId, Task task) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      final project = _projects[index];
      final updatedTasks = [...project.tasks, task];

      _projects[index] = project.copyWith(
        tasks: updatedTasks,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void toggleTaskCompletion(String projectId, String taskId) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      final project = _projects[index];
      final updatedTasks = project.tasks.map((task) {
        if (task.id == taskId) {
          return task.copyWith(isCompleted: !task.isCompleted);
        }
        return task;
      }).toList();

      _projects[index] = project.copyWith(
        tasks: updatedTasks,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  Future<void> updateProjectProgress(String id, double progress) async {
    try {
      await _projectService.updateProjectProgress(id, progress);
      final index = _projects.indexWhere((p) => p.id == id);
      if (index != -1) {
        _projects[index] = _projects[index].copyWith(
          status: progress == 1.0
              ? ProjectStatus.completed
              : ProjectStatus.inProgress,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating project progress: $e');
    }
  }

  Future<void> updateProjectStatus(String id, ProjectStatus status) async {
    try {
      await _projectService.updateProjectStatus(id, status);
      final index = _projects.indexWhere((p) => p.id == id);
      if (index != -1) {
        _projects[index] = _projects[index].copyWith(status: status);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating project status: $e');
    }
  }

  Future<void> addMilestone(
      String projectId, Map<String, String> milestone) async {
    try {
      final project = _projects.firstWhere((p) => p.id == projectId);
      final updatedMilestones = [...project.milestones, milestone];
      final updatedProject = project.copyWith(milestones: updatedMilestones);
      updateProject(updatedProject);
    } catch (e) {
      debugPrint('Error adding milestone: $e');
    }
  }

  Future<void> addTeamMember(String projectId, String member) async {
    try {
      final project = _projects.firstWhere((p) => p.id == projectId);
      final updatedMembers = [...project.teamMembers, member];
      final updatedProject = project.copyWith(teamMembers: updatedMembers);
      updateProject(updatedProject);
    } catch (e) {
      debugPrint('Error adding team member: $e');
    }
  }

  Future<void> updateBudget(
      String projectId, double budget, double spent) async {
    try {
      final project = _projects.firstWhere((p) => p.id == projectId);
      final updatedProject = project.copyWith(budget: budget, spent: spent);
      updateProject(updatedProject);
    } catch (e) {
      debugPrint('Error updating budget: $e');
    }
  }
}
