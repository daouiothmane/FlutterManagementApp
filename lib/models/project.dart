import 'package:flutter/material.dart';

enum ProjectStatus {
  notStarted,
  inProgress,
  completed,
  onHold,
  cancelled,
}

class Project {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Color color;
  final List<Task> tasks;
  final List<Map<String, String>> milestones;
  final List<String> teamMembers;
  final double budget;
  final double spent;
  final ProjectStatus status;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.color,
    this.tasks = const [],
    this.milestones = const [],
    this.teamMembers = const [],
    this.budget = 0.0,
    this.spent = 0.0,
    this.status = ProjectStatus.notStarted,
  });

  double get progress {
    if (tasks.isEmpty) return 0.0;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    return completedTasks / tasks.length;
  }

  Color get statusColor {
    switch (status) {
      case ProjectStatus.notStarted:
        return Colors.red;
      case ProjectStatus.inProgress:
        return Colors.orange;
      case ProjectStatus.completed:
        return Colors.green;
      case ProjectStatus.onHold:
        return Colors.blue;
      case ProjectStatus.cancelled:
        return Colors.grey;
    }
  }

  Project copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    Color? color,
    List<Task>? tasks,
    List<Map<String, String>>? milestones,
    List<String>? teamMembers,
    double? budget,
    double? spent,
    ProjectStatus? status,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      color: color ?? this.color,
      tasks: tasks ?? this.tasks,
      milestones: milestones ?? this.milestones,
      teamMembers: teamMembers ?? this.teamMembers,
      budget: budget ?? this.budget,
      spent: spent ?? this.spent,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'progress': progress,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'color': color.toARGB32(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'milestones': milestones,
      'teamMembers': teamMembers,
      'budget': budget,
      'spent': spent,
      'status': status.toString(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      color: Color(json['color']),
      tasks: List<Task>.from(
          json['tasks'].map((taskJson) => Task.fromJson(taskJson))),
      milestones: List<Map<String, String>>.from(json['milestones'] ?? []),
      teamMembers: List<String>.from(json['teamMembers'] ?? []),
      budget: json['budget']?.toDouble() ?? 0.0,
      spent: json['spent']?.toDouble() ?? 0.0,
      status: ProjectStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => ProjectStatus.notStarted,
      ),
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
