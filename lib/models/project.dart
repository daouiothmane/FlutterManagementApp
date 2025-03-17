import 'package:flutter/material.dart';

enum ProjectStatus { notStarted, inProgress, completed, onHold }

class Project {
  final String id;
  final String name;
  final double progress;
  final String description;
  final DateTime createdAt;
  final Color color;
  final ProjectStatus status;
  final List<String> teamMembers;
  final List<Map<String, dynamic>> tasks;
  final List<Map<String, dynamic>> milestones;
  final List<Map<String, dynamic>> documents;
  final List<Map<String, dynamic>> expenses;
  final List<Map<String, dynamic>> notes;
  final double budget;
  final double spent;

  Project({
    required this.id,
    required this.name,
    required this.progress,
    required this.description,
    required this.createdAt,
    required this.color,
    this.status = ProjectStatus.notStarted,
    this.teamMembers = const [],
    this.tasks = const [],
    this.milestones = const [],
    this.documents = const [],
    this.expenses = const [],
    this.notes = const [],
    this.budget = 0.0,
    this.spent = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'progress': progress,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'color': color.toARGB32(),
      'status': status.index,
      'teamMembers': teamMembers,
      'tasks': tasks,
      'milestones': milestones,
      'documents': documents,
      'expenses': expenses,
      'notes': notes,
      'budget': budget,
      'spent': spent,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
      progress: map['progress'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      color: Color(map['color']),
      status: ProjectStatus.values[map['status']],
      teamMembers: List<String>.from(map['teamMembers']),
      tasks: List<Map<String, dynamic>>.from(map['tasks']),
      milestones: List<Map<String, dynamic>>.from(map['milestones']),
      documents: List<Map<String, dynamic>>.from(map['documents']),
      expenses: List<Map<String, dynamic>>.from(map['expenses']),
      notes: List<Map<String, dynamic>>.from(map['notes']),
      budget: map['budget'],
      spent: map['spent'],
    );
  }

  Project copyWith({
    String? id,
    String? name,
    double? progress,
    String? description,
    DateTime? createdAt,
    Color? color,
    ProjectStatus? status,
    List<String>? teamMembers,
    List<Map<String, dynamic>>? tasks,
    List<Map<String, dynamic>>? milestones,
    List<Map<String, dynamic>>? documents,
    List<Map<String, dynamic>>? expenses,
    List<Map<String, dynamic>>? notes,
    double? budget,
    double? spent,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      progress: progress ?? this.progress,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      status: status ?? this.status,
      teamMembers: teamMembers ?? this.teamMembers,
      tasks: tasks ?? this.tasks,
      milestones: milestones ?? this.milestones,
      documents: documents ?? this.documents,
      expenses: expenses ?? this.expenses,
      notes: notes ?? this.notes,
      budget: budget ?? this.budget,
      spent: spent ?? this.spent,
    );
  }
}
