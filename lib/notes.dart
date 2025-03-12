import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool _isDarkMode = false;
  List<Map<String, String>> _notes = [];

  void _addOrUpdateNote({Map<String, String>? note, int? index}) {
    TextEditingController titleController =
        TextEditingController(text: note?['title']);
    TextEditingController descriptionController =
        TextEditingController(text: note?['description']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note == null ? 'Add Note' : 'Update Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: 'Description'),
            ),
          ],
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
              if (titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                setState(() {
                  if (note == null) {
                    _notes.add({
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'date': DateTime.now().toLocal().toString().split(' ')[0],
                    });
                  } else {
                    _notes[index!] = {
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'date': DateTime.now().toLocal().toString().split(' ')[0],
                    };
                  }
                });
                Navigator.pop(context);
              }
            },
            child: Text(note == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _removeNoteAt(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Notes'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _addOrUpdateNote();
              },
            ),
            Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
          ],
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            final note = _notes[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${note['date']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      note['title']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      note['description']!,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.share, color: Colors.white),
                              onPressed: () {
                                // Share action
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.save, color: Colors.white),
                              onPressed: () {
                                // Save action
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                _addOrUpdateNote(note: note, index: index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                _removeNoteAt(index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.bookmark, color: Colors.white),
                              onPressed: () {
                                // Bookmark action
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
