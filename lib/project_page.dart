import 'package:flutter/material.dart';
import 'models/project.dart';

class ProjectPage extends StatefulWidget {
  final Project project;

  const ProjectPage({Key? key, required this.project}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_project.name),
        backgroundColor: _project.color,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Dashboard'),
            Tab(text: 'Tasks'),
            Tab(text: 'Team'),
            Tab(text: 'Files'),
            Tab(text: 'Budget'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
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
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _project.color,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(_project.progress * 100).toInt()}%',
                      style: TextStyle(
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: Colors.white.withAlpha(77),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(),
                SizedBox(height: 20),
                _buildMilestonesCard(),
                SizedBox(height: 20),
                _buildTeamOverviewCard(),
                SizedBox(height: 20),
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ProjectStatus.values.map((status) {
                  bool isSelected = _project.status == status;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _project = _project.copyWith(status: status);
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? _project.color : Colors.grey[200],
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Milestones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // TODO: Implement add milestone
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_project.milestones.isEmpty)
              Center(
                child: Text('No milestones set'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _project.milestones.length,
                itemBuilder: (context, index) {
                  final milestone = _project.milestones[index];
                  return ListTile(
                    leading: Icon(Icons.flag),
                    title: Text(milestone['title']),
                    subtitle: Text(milestone['dueDate']),
                    trailing: IconButton(
                      icon: Icon(Icons.check_circle),
                      onPressed: () {
                        // TODO: Implement milestone completion
                      },
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
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
            SizedBox(height: 16),
            if (_project.teamMembers.isEmpty)
              Center(
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Budget'),
                    Text(
                      '\$${_project.budget.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Spent'),
                    Text(
                      '\$${_project.spent.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: _project.budget > 0 ? _project.spent / _project.budget : 0,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasks() {
    return Center(child: Text('Tasks View - Coming Soon'));
  }

  Widget _buildTeam() {
    return Center(child: Text('Team View - Coming Soon'));
  }

  Widget _buildFiles() {
    return Center(child: Text('Files View - Coming Soon'));
  }

  Widget _buildBudget() {
    return Center(child: Text('Budget View - Coming Soon'));
  }

  Widget _buildFloatingActionButton() {
    switch (_selectedTab) {
      case 0:
        return FloatingActionButton(
          backgroundColor: _project.color,
          onPressed: () {
            // TODO: Implement add milestone
          },
          child: Icon(Icons.add),
        );
      case 1:
        return FloatingActionButton(
          backgroundColor: _project.color,
          onPressed: () {
            // TODO: Implement add task
          },
          child: Icon(Icons.add_task),
        );
      case 2:
        return FloatingActionButton(
          backgroundColor: _project.color,
          onPressed: () {
            // TODO: Implement add team member
          },
          child: Icon(Icons.person_add),
        );
      case 3:
        return FloatingActionButton(
          backgroundColor: _project.color,
          onPressed: () {
            // TODO: Implement add file
          },
          child: Icon(Icons.upload_file),
        );
      case 4:
        return FloatingActionButton(
          backgroundColor: _project.color,
          onPressed: () {
            // TODO: Implement add expense
          },
          child: Icon(Icons.add_circle),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildProjectOptions() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Project'),
            onTap: () {
              // TODO: Implement edit project
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Project'),
            onTap: () {
              // TODO: Implement delete project
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share Project'),
            onTap: () {
              // TODO: Implement share project
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
