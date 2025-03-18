import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../models/project.dart';
import '../../providers/project_provider.dart';
import '../projects/project_page.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/project_dialog.dart';
import '../../constants/app_theme.dart';
import '../tasks/todo_list_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _statusController;
  bool _isEditing = false;
  String? _selectedImagePath;
  List<Project> _projects = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'John Doe');
    _statusController = TextEditingController(text: 'Active');
    _loadProjects();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _loadProjects() async {
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);
    await projectProvider.loadProjects();
    setState(() {
      _projects = projectProvider.projects;
    });
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveProfile() {
    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
      // TODO: Implement image storage and update profile image
    }
  }

  void _addNewProject() async {
    final result = await showDialog<Project>(
      context: context,
      builder: (context) => const ProjectDialog(),
    );

    if (result != null && mounted) {
      context.read<ProjectProvider>().addProject(result);
      await _loadProjects(); // Reload projects after adding new one
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _startEditing,
            ),
          const IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          ),
        ],
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(bottom: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12.0),
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
                              backgroundImage: _selectedImagePath != null
                                  ? FileImage(File(_selectedImagePath!))
                                  : AssetImage('assets/images/profile.jpg')
                                      as ImageProvider,
                              child: _isEditing
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(128),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _isEditing
                              ? TextField(
                                  controller: _nameController,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  _nameController.text,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                          const SizedBox(height: 8),
                          _isEditing
                              ? TextField(
                                  controller: _statusController,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFE0E0E0),
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  _statusController.text,
                                  style: const TextStyle(
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
                  children: [
                    _buildTaskCard(
                      'To Do',
                      '${TodoListPage.inProgressTasks} tasks now, ${TodoListPage.inProgressTasks} started',
                      Colors.blue,
                    ),
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
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Projects',
                        style: AppTheme.subtitleStyle,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: _addNewProject,
                      ),
                    ],
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: projectProvider.projects.length,
                  itemBuilder: (context, index) {
                    final project = projectProvider.projects[index];
                    return _buildProjectCard(project);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyTasksCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TodoListPage(title: 'My Tasks'),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.green,
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
                    style: AppTheme.titleStyle.copyWith(color: Colors.white),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Manage your daily tasks and to-dos',
                style: TextStyle(
                  color: Colors.white.withAlpha(204),
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
        color: color.withAlpha(51),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.subtitleStyle,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: AppTheme.bodyStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectPage(project: project),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: project.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  project.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: project.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  project.status.toString().split('.').last,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: project.statusColor,
                  ),
                ),
              ),
              Text(
                'Created: ${project.createdAt.toString().split(' ')[0]}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
