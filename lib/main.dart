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
  List<TodoItem> _todoItems = [
    TodoItem(title: 'Tarefa 1'),
    TodoItem(title: 'Tarefa 2'),
    TodoItem(title: 'Tarefa 3'),
    TodoItem(title: 'Tarefa 4'),
    TodoItem(title: 'Tarefa 5'),
  ];

  void _toggleTask(int index) {
    setState(() {
      _todoItems[index].isDone = !_todoItems[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
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
          );
        },
      ),
    );
  }
}

class TodoItem {
  final String title;
  bool isDone;

  TodoItem({required this.title, this.isDone = false});
}
