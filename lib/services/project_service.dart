import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';

class ProjectService {
  static const String _storageKey = 'projects';
  late SharedPreferences _prefs;

  ProjectService() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Project>> getProjects() async {
    try {
      final String? projectsJson = _prefs.getString(_storageKey);
      if (projectsJson == null) return [];

      final List<dynamic> projectsList = json.decode(projectsJson);
      return projectsList.map((json) => Project.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error getting projects: $e');
      return [];
    }
  }

  Future<void> addProject(Project project) async {
    try {
      final projects = await getProjects();
      projects.add(project);
      await _saveProjects(projects);
    } catch (e) {
      debugPrint('Error adding project: $e');
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      final projects = await getProjects();
      final index = projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        projects[index] = project;
        await _saveProjects(projects);
      }
    } catch (e) {
      debugPrint('Error updating project: $e');
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      final projects = await getProjects();
      projects.removeWhere((project) => project.id == id);
      await _saveProjects(projects);
    } catch (e) {
      debugPrint('Error deleting project: $e');
    }
  }

  Future<void> updateProjectProgress(String id, double progress) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> updateProjectStatus(String id, ProjectStatus status) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> addMilestone(
      String projectId, Map<String, String> milestone) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> addTeamMember(String projectId, String member) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> updateBudget(
      String projectId, double budget, double spent) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _saveProjects(List<Project> projects) async {
    try {
      final String projectsJson =
          json.encode(projects.map((p) => p.toJson()).toList());
      await _prefs.setString(_storageKey, projectsJson);
    } catch (e) {
      debugPrint('Error saving projects: $e');
    }
  }

  // TODO: Implement actual API calls when backend is ready:
  // 1. Add proper API endpoints for CRUD operations
  // 2. Implement error handling for API failures
  // 3. Add request/response validation
  // 4. Implement proper data caching strategy
  Future<void> loadProjects() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> saveProjects() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }
}
