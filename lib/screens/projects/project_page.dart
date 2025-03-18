import 'package:flutter/material.dart';
import '../../models/project.dart';

class ProjectPage extends StatefulWidget {
  final Project project;

  const ProjectPage({Key? key, required this.project}) : super(key: key);

  @override
  State<ProjectPage> createState() => ProjectPageState();
}

class ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {
  late Project _project;
  late TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addMilestone() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Milestone'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter milestone title',
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    final newMilestones =
                        List<Map<String, String>>.from(_project.milestones);
                    newMilestones.add({
                      'title': value,
                      'dueDate': DateTime.now().toString().split(' ')[0],
                      'completed': 'false',
                    });
                    _project = _project.copyWith(milestones: newMilestones);
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _completeMilestone(int index) {
    setState(() {
      final newMilestones = List<Map<String, String>>.from(_project.milestones);
      newMilestones[index] = Map<String, String>.from(newMilestones[index])
        ..['completed'] = 'true';
      _project = _project.copyWith(milestones: newMilestones);
    });
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: const Text('Task functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addTeamMember() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Team Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter team member name',
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _project.teamMembers.add(value);
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addFile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add File'),
        content: const Text('File upload functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter expense amount',
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    final newSpent =
                        _project.spent + (double.tryParse(value) ?? 0);
                    _project = _project.copyWith(spent: newSpent);
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editProject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter project name',
              ),
              controller: TextEditingController(text: _project.name),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _project = _project.copyWith(name: value);
                  });
                  Navigator.pop(context);
                }
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter project description',
              ),
              controller: TextEditingController(text: _project.description),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _project = _project.copyWith(description: value);
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteProject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous screen
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _shareProject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Project'),
        content: const Text('Sharing functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_project.name),
        backgroundColor: _project.color,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Tasks'),
            Tab(text: 'Team'),
            Tab(text: 'Files'),
            Tab(text: 'Budget'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildProjectOptions(),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboard(),
          _buildTasks(),
          _buildTeam(),
          _buildFiles(),
          _buildBudget(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _project.color,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Project Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(_project.progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: _project.progress,
                        strokeWidth: 8,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: Colors.white.withAlpha(77),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(),
                const SizedBox(height: 20),
                _buildMilestonesCard(),
                const SizedBox(height: 20),
                _buildTeamOverviewCard(),
                const SizedBox(height: 20),
                _buildBudgetOverviewCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ProjectStatus.values.map((status) {
                  bool isSelected = _project.status == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _project = _project.copyWith(status: status);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _project.statusColor
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.toString().split('.').last,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[800],
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestonesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Milestones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addMilestone,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_project.milestones.isEmpty)
              const Center(
                child: Text('No milestones set'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _project.milestones.length,
                itemBuilder: (context, index) {
                  final milestone = _project.milestones[index];
                  return ListTile(
                    leading: const Icon(Icons.flag),
                    title: Text(milestone['title'] ?? ''),
                    subtitle: Text(milestone['dueDate'] ?? ''),
                    trailing: IconButton(
                      icon: Icon(
                        milestone['completed'] == 'true'
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                      ),
                      onPressed: () => _completeMilestone(index),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamOverviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Team Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_project.teamMembers.length} members',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_project.teamMembers.isEmpty)
              const Center(
                child: Text('No team members added'),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _project.teamMembers.map((member) {
                  return Chip(
                    avatar: CircleAvatar(
                      child: Text(member[0]),
                    ),
                    label: Text(member),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetOverviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Budget Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Budget'),
                    Text(
                      '\$${_project.budget.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Spent'),
                    Text(
                      '\$${_project.spent.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _project.budget > 0 ? _project.spent / _project.budget : 0,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasks() {
    return const Center(child: Text('Tasks View - Coming Soon'));
  }

  Widget _buildTeam() {
    return const Center(child: Text('Team View - Coming Soon'));
  }

  Widget _buildFiles() {
    return const Center(child: Text('Files View - Coming Soon'));
  }

  Widget _buildBudget() {
    return const Center(child: Text('Budget View - Coming Soon'));
  }

  Widget _buildFloatingActionButton() {
    switch (_selectedTab) {
      case 0:
        return FloatingActionButton(
          backgroundColor: _project.color,
          onPressed: _addMilestone,
          child: const Icon(Icons.add),
        );
      case 1:
        return FloatingActionButton(
          backgroundColor: _project.color,
          onPressed: _addTask,
          child: const Icon(Icons.add_task),
        );
      case 2:
        return FloatingActionButton(
          backgroundColor: _project.color,
          onPressed: _addTeamMember,
          child: const Icon(Icons.person_add),
        );
      case 3:
        return FloatingActionButton(
          backgroundColor: _project.color,
          onPressed: _addFile,
          child: const Icon(Icons.upload_file),
        );
      case 4:
        return FloatingActionButton(
          backgroundColor: _project.color,
          onPressed: _addExpense,
          child: const Icon(Icons.add_circle),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildProjectOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Project'),
            onTap: () {
              _editProject();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Project'),
            onTap: () {
              _deleteProject();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Project'),
            onTap: () {
              _shareProject();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
