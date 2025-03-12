import 'package:flutter/material.dart';
import 'tasks.dart'; // Import the tasks.dart file

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        // Handle the selected date
      });
    }
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
                      CircleAvatar(
                        radius: 50, // Increased radius for a larger circle
                        backgroundImage: AssetImage(
                          'assets/profile.png',
                        ), // Replace with your profile image asset path
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
                          backgroundColor:
                              Colors
                                  .grey, // Gray color for the rest of the circle
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Space between image and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        'Sourav Suman',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text
                        ),
                      ),
                      SizedBox(height: 8), // Margin between name and role
                      Text(
                        'App Developer',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFE0E0E0), // Light gray text
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'My Tasks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildTaskCard('To Do', '5 tasks now, 1 started', Colors.blue),
                _buildTaskCard(
                  'In Progress',
                  '1 tasks now, 1 started',
                  Colors.orange,
                ),
                _buildTaskCard(
                  'Done',
                  '18 tasks now, 13 started',
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Active Projects',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436), // Dark gray text
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildProjectCard(
                  'Making History',
                  0.25,
                  '9 hours progress',
                  Colors.green,
                ),
                _buildProjectCard(
                  'Medical App',
                  0.60,
                  '20 hours progress',
                  Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildProjectCard(
                  'E-commerce Platform',
                  0.45,
                  '15 hours progress',
                  Colors.purple,
                ),
                _buildProjectCard(
                  'Social Media App',
                  0.80,
                  '32 hours progress',
                  Colors.red,
                ),
              ],
            ),
          ],
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

  Widget _buildProjectCard(
    String title,
    double progress,
    String subtitle,
    Color color,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TasksPage()),
          );
        },
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436), // Dark gray text
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8.0,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF636E72), // Gray text
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB2BEC3), // Light gray text
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
