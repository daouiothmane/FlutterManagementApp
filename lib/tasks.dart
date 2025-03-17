import 'package:flutter/material.dart';
import 'settings.dart'; // Import the settings page
import 'profile.dart'; // Import the profile page
import 'schedule.dart'; // Import the schedule page
import 'notes.dart'; // Import the notes page
import 'bills.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => TasksPageState();
}

class TasksPageState extends State<TasksPage> {
  int _selectedIndex = 0;
  final List<String> _labels = [
    'Profile',
    'Schedule',
    'Bills',
    'Notes',
    'Settings',
  ];

  final List<IconData> _icons = [
    Icons.person,
    Icons.schedule,
    Icons.receipt,
    Icons.note,
    Icons.settings,
  ];

  final Map<DateTime, List<String>> _events = {};
  final List<Map<String, dynamic>> _tasks = [];
  DateTime _selectedDay = DateTime.now();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addEvent(String event) {
    if (_events[_selectedDay] != null) {
      _events[_selectedDay]!.add(event);
    } else {
      _events[_selectedDay] = [event];
    }
    setState(() {});
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(task['title'] ?? ''),
        subtitle: Text(task['description'] ?? ''),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              _tasks.remove(task);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 1
          ? SchedulePage()
          : _selectedIndex == 4
              ? SettingsPage()
              : _selectedIndex == 0
                  ? ProfilePage()
                  : _selectedIndex == 3
                      ? NotesPage()
                      : _selectedIndex == 2
                          ? BillsPage()
                          : Center(
                              child:
                                  Text('Selected: ${_labels[_selectedIndex]}')),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: List.generate(_labels.length, (index) {
            return Expanded(
              child: GestureDetector(
                onTap: () => _onItemTapped(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.translate(
                      offset: _selectedIndex == index
                          ? Offset(0, -10)
                          : Offset(0, 0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: _selectedIndex == index ? 48.0 : 40.0,
                        height: _selectedIndex == index ? 48.0 : 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedIndex == index
                              ? Colors.green
                              : Colors.transparent,
                        ),
                        child: Icon(
                          _icons[index],
                          color: _selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Transform.translate(
                      offset: _selectedIndex == index
                          ? Offset(0, -5)
                          : Offset(0, 0),
                      child: Text(
                        _labels[index],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: _selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showAddEventDialog() {
    TextEditingController eventController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Event'),
        content: TextField(
          controller: eventController,
          decoration: InputDecoration(hintText: 'Enter event'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (eventController.text.isNotEmpty) {
                _addEvent(eventController.text);
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 47, 0, 255),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 169, 235),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
            painter: WavePainter(),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ), // Adjust this value to position the logo vertically
                CircleAvatar(
                  radius: 60, // Increased radius for a larger circle
                  backgroundImage: AssetImage(
                    'assets/logo.jpg',
                  ), // Replace with your logo asset path
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: _emailFocusNode.hasFocus
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.blue),
                          border: InputBorder.none,
                          labelText: 'Email address',
                          labelStyle: TextStyle(color: Colors.blue),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: _passwordFocusNode.hasFocus
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.blue),
                          border: InputBorder.none,
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.blue),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            const Text('Remember me'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle forgot password action
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 100, // Adjust the width to fit the "LOGIN" text
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Navigate to TasksPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TasksPage(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialLoginButton('assets/google.png', () {
                          // Handle Google login
                        }),
                        _buildSocialLoginButton('assets/github.png', () {
                          // Handle GitHub login
                        }),
                        _buildSocialLoginButton('assets/twitter.png', () {
                          // Handle Twitter login
                        }),
                        _buildSocialLoginButton('assets/facebook.png', () {
                          // Handle Facebook login
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Navigate to SignUpPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Create account',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLoginButton(String assetPath, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        radius: 20, // Smaller radius for smaller circle
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Image.asset(assetPath),
          iconSize: 20, // Smaller icon size
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 76, 169, 235)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(
        0,
        size.height * 0.3,
      ) // Adjusted height to make the blue area smaller
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.25,
        size.width * 0.5,
        size.height * 0.3,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.35,
        size.width,
        size.height * 0.3,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _repeatPasswordFocusNode = FocusNode();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 169, 235),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
            painter: WavePainter(),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ), // Adjust this value to position the logo vertically
                CircleAvatar(
                  radius: 60, // Increased radius for a larger circle
                  backgroundImage: AssetImage(
                    'assets/logo.jpg',
                  ), // Replace with your logo asset path
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: _emailFocusNode.hasFocus
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email, color: Colors.blue),
                            border: InputBorder.none,
                            labelText: 'e-mail',
                            labelStyle: TextStyle(color: Colors.blue),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: _passwordFocusNode.hasFocus
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Colors.blue),
                            border: InputBorder.none,
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.blue),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: _repeatPasswordFocusNode.hasFocus
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: TextFormField(
                          controller: _repeatPasswordController,
                          focusNode: _repeatPasswordFocusNode,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Colors.blue),
                            border: InputBorder.none,
                            labelText: 'Repeat Password',
                            labelStyle: TextStyle(color: Colors.blue),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please repeat your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value!;
                              });
                            },
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialLoginButton('assets/google.png', () {
                            // Handle Google sign-up
                          }),
                          _buildSocialLoginButton('assets/github.png', () {
                            // Handle GitHub sign-up
                          }),
                          _buildSocialLoginButton('assets/twitter.png', () {
                            // Handle Twitter sign-up
                          }),
                          _buildSocialLoginButton('assets/facebook.png', () {
                            // Handle Facebook sign-up
                          }),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width:
                            100, // Adjust the width to fit the "Sign up" text
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Navigate to TasksPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TasksPage(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLoginButton(String assetPath, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        radius: 20, // Smaller radius for smaller circle
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Image.asset(assetPath),
          iconSize: 20, // Smaller icon size
          onPressed: onPressed,
        ),
      ),
    );
  }
}
