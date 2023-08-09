
import 'package:flutter/material.dart';

void main() {
  runApp(TaskListApp());
}

class TaskListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class Task {
  final String name;
  bool isDone;
  String comment;

  Task(this.name, {this.isDone = false, this.comment = ''});
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  String currentFolder = "Default Folder";

  void addTask(String name) {
    setState(() {
      tasks.add(Task(name));
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
      if (tasks[index].isDone) {
        Task completedTask = tasks.removeAt(index);
        tasks.add(completedTask);
      }
    });
  }

  void addComment(int index, String comment) {
    setState(() {
      tasks[index].comment = comment;
    });
  }

  void openCommentScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentScreen(
          task: tasks[index],
          onCommentAdded: (comment) {
            addComment(index, comment);
          },
        ),
      ),
    );
  }

  void createFolder(String folderName) {
    setState(() {
      currentFolder = folderName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index].name),
            onTap: () {
              toggleTask(index);
            },
            onLongPress: () {
              openCommentScreen(index);
            },
            trailing: tasks[index].isDone
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
          );
        },
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              title: Text('Folders'),
              subtitle: Text(currentFolder),
            ),
            Divider(),
            ListTile(
              title: Text('Create Folder'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => CreateFolderDialog(
                    onCreateFolder: createFolder,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String taskName = await showDialog(
            context: context,
            builder: (context) => TaskDialog(),
          );
          if (taskName != null) {
            addTask(taskName);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TaskDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String taskName = '';

    return AlertDialog(
      title: Text('Add Task'),
      content: TextField(
        onChanged: (value) {
          taskName = value;
        },
        decoration: InputDecoration(labelText: 'Task name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, taskName);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

class CommentScreen extends StatefulWidget {
  final Task task;
  final Function(String) onCommentAdded;

  CommentScreen({required this.task, required this.onCommentAdded});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  String comment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Task: ${widget.task.name}'),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  comment = value;
                });
              },
              decoration: InputDecoration(labelText: 'Comment'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onCommentAdded(comment);
                Navigator.pop(context);
              },
              child: Text('Add Comment'),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateFolderDialog extends StatelessWidget {
  final Function(String) onCreateFolder;

  CreateFolderDialog({required this.onCreateFolder});

  @override
  Widget build(BuildContext context) {
    String folderName = '';

    return AlertDialog(
      title: Text('Create Folder'),
      content: TextField(
        onChanged: (value) {
          folderName = value;
        },
        decoration: InputDecoration(labelText: 'Folder name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (folderName.isNotEmpty) {
              onCreateFolder(folderName);
            }
            Navigator.pop(context);
          },
          child: Text('Create'),
        ),
      ],
    );
  }
}
