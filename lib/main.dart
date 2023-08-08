import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> _todoItems = [];

  TextEditingController _taskController = TextEditingController();

  void _toggleTask(int index) {
    setState(() {
      _todoItems[index].isDone = !_todoItems[index].isDone;

      if (_todoItems[index].isDone) {
        final doneTask = _todoItems.removeAt(index);
        _todoItems.add(doneTask);
      }
    });
  }

  void _addTask(String taskTitle) {
    if (taskTitle.isNotEmpty) {
      setState(() {
        _todoItems.add(TodoItem(title: taskTitle));
        _taskController.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _todoItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_todoItems[index].title),
                  onDismissed: (_) => _deleteTask(index),
                  child: GestureDetector(
                    onTap: () => _toggleTask(index),
                    child: ListTile(
                      title: Text(
                        _todoItems[index].title,
                        style: TextStyle(
                          decoration: _todoItems[index].isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0), 
            child: Row(
              children: [
                Expanded(
                  child: Visibility(
                    visible: _taskController.text.isNotEmpty,
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Adicionar tarefa...',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addTask(_taskController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItem {
  final String title;
  bool isDone;

  TodoItem({required this.title, this.isDone = false});
}
