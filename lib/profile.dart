import 'package:flutter/material.dart';
import 'todo_list_page.dart';
import 'models/project.dart';
import 'project_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _name = 'John Doe';
  String _status = 'Available';
  final String _profileImagePath = 'assets/images/profile.jpg';
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  List<Project> _projects = [
    Project(
      id: '1',
      name: 'Making History',
      progress: 0.25,
      description: 'A historical documentation app',
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      color: Colors.green,
    ),
    Project(
      id: '2',
      name: 'Medical App',
      progress: 0.60,
      description: 'Healthcare management system',
      createdAt: DateTime.now().subtract(Duration(days: 45)),
      color: Colors.blue,
    ),
    Project(
      id: '3',
      name: 'E-commerce Platform',
      progress: 0.45,
      description: 'Online shopping platform',
      createdAt: DateTime.now().subtract(Duration(days: 15)),
      color: Colors.purple,
    ),
    Project(
      id: '4',
      name: 'Social Media App',
      progress: 0.80,
      description: 'Social networking platform',
      createdAt: DateTime.now().subtract(Duration(days: 60)),
      color: Colors.red,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 0.75).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
    _nameController.text = _name;
    _statusController.text = _status;
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _name = _nameController.text;
        _status = _statusController.text;
      }
    });
  }

  Future<void> _pickImage() async {
    // TODO: Implement image picking functionality
  }

  void _addNewProject() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Project'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Project Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Color>(
                value: selectedColor,
                decoration: InputDecoration(
                  labelText: 'Project Color',
                  border: OutlineInputBorder(),
                ),
                items: [
                  Colors.blue,
                  Colors.green,
                  Colors.red,
                  Colors.purple,
                  Colors.orange,
                ].map((color) {
                  String colorName = 'Blue';
                  if (color == Colors.green) colorName = 'Green';
                  if (color == Colors.red) colorName = 'Red';
                  if (color == Colors.purple) colorName = 'Purple';
                  if (color == Colors.orange) colorName = 'Orange';

                  return DropdownMenuItem(
                    value: color,
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(colorName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (color) {
                  selectedColor = color!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                final newProject = Project(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  progress: 0.0,
                  description: descriptionController.text,
                  createdAt: DateTime.now(),
                  color: selectedColor,
                );

                setState(() {
                  _projects.add(newProject);
                });

                Navigator.pop(context);
              }
            },
            child: Text('Add Project'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle menu button press
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEditMode,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 24.0),
              decoration: BoxDecoration(
                color: Colors.orange, // Orange background
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: _isEditing ? _pickImage : null,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(_profileImagePath),
                          child: _isEditing
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(
                        width:
                            100, // Reduced width to make the distance almost null
                        height:
                            100, // Reduced height to make the distance almost null
                        child: CircularProgressIndicator(
                          value:
                              _animation.value, // Use the animated value here
                          strokeWidth: 8.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green, // Green color for achieved progress
                          ),
                          backgroundColor: Colors
                              .grey, // Gray color for the rest of the circle
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Space between image and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _isEditing
                          ? TextField(
                              controller: _nameController,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              _name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                      SizedBox(height: 8), // Margin between name and role
                      _isEditing
                          ? TextField(
                              controller: _statusController,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFE0E0E0),
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              _status,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            _buildMyTasksCard(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildTaskCard(
                    'To Do',
                    '${TodoListPage.inProgressTasks} tasks now, ${TodoListPage.inProgressTasks} started',
                    Colors.blue),
                _buildTaskCard(
                  'In Progress',
                  '${TodoListPage.inProgressTasks} tasks now, ${TodoListPage.inProgressTasks} started',
                  Colors.orange,
                ),
                _buildTaskCard(
                  'Done',
                  '${TodoListPage.completedTasks} tasks now, ${TodoListPage.completedTasks} started',
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Projects',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: _addNewProject,
                  ),
                ],
              ),
            ),
            // Display projects in pairs
            ...List.generate(
              (_projects.length / 2).ceil(),
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _projects
                      .skip(index * 2)
                      .take(2)
                      .map((project) => _buildProjectCard(project))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyTasksCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoListPage(title: 'My Tasks'),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.green, // Added green background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors
                          .white, // Changed text color to white for better contrast
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.white), // Changed icon color to white
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Manage your daily tasks and to-dos',
                style: TextStyle(
                  color: Colors.white.withOpacity(
                      0.8), // Changed text color to white with opacity
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(String title, String subtitle, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(
          0.2,
        ), // Set the background color with some opacity
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectPage(project: project),
            ),
          );
        },
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: project.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        project.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: project.progress,
                        strokeWidth: 8.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(project.color),
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    Text(
                      '${(project.progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Created ${project.createdAt.toString().split(' ')[0]}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
