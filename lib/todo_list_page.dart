import 'package:flutter/material.dart';

class TodoItem {
  String title;
  bool isCompleted;
  DateTime createdAt;

  TodoItem({
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class TodoListPage extends StatefulWidget {
  final String title;
  static int totalTasks = 0;
  static int completedTasks = 0;
  static int inProgressTasks = 0;

  const TodoListPage({Key? key, required this.title}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<TodoItem> _todos = [];
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  int? _editingIndex;

  void _updateTaskCounts() {
    TodoListPage.totalTasks = _todos.length;
    TodoListPage.completedTasks =
        _todos.where((todo) => todo.isCompleted).length;
    TodoListPage.inProgressTasks =
        _todos.where((todo) => !todo.isCompleted).length;
  }

  void _addTodo(String title) {
    if (title.isNotEmpty) {
      setState(() {
        _todos.add(TodoItem(title: title));
        _updateTaskCounts();
      });
      _textController.clear();
    }
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
      _updateTaskCounts();
    });
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
      _updateTaskCounts();
    });
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _editController.text = _todos[index].title;
    });
  }

  void _saveEdit() {
    if (_editingIndex != null && _editController.text.isNotEmpty) {
      setState(() {
        _todos[_editingIndex!].title = _editController.text;
        _editingIndex = null;
        _updateTaskCounts();
      });
      _editController.clear();
    }
  }

  void _cancelEdit() {
    setState(() {
      _editingIndex = null;
    });
    _editController.clear();
  }

  @override
  void initState() {
    super.initState();
    _updateTaskCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Add a new task',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      onSubmitted: _addTodo,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.blue),
                    onPressed: () => _addTodo(_textController.text),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tasks (${_todos.length})',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Completed: ${_todos.where((todo) => todo.isCompleted).length}',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                final isEditing = _editingIndex == index;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (bool? value) => _toggleTodo(index),
                        activeColor: Colors.green,
                      ),
                      title: isEditing
                          ? TextField(
                              controller: _editController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                              autofocus: true,
                            )
                          : Text(
                              todo.title,
                              style: TextStyle(
                                decoration: todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: todo.isCompleted ? Colors.grey : null,
                                fontSize: 16,
                              ),
                            ),
                      subtitle: Text(
                        'Created: ${_formatDate(todo.createdAt)}',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isEditing)
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: _saveEdit,
                            ),
                          if (isEditing)
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: _cancelEdit,
                            ),
                          if (!isEditing)
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _startEditing(index),
                            ),
                          if (!isEditing)
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeTodo(index),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _textController.dispose();
    _editController.dispose();
    super.dispose();
  }
}
