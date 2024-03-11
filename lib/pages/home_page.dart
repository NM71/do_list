import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isDarkMode;
  final List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    isDarkMode = false;
    loadTasks(); // Load tasks when the app starts
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskNames = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks.clear();
      tasks.addAll(taskNames.map((name) => Task(name: name)));
    });
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskNames = tasks.map((task) => task.name).toList();
    await prefs.setStringList('tasks', taskNames);
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        final taskController = TextEditingController();
        return AlertDialog(
          title: Text(
            'New Task',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: 'Enter Task..',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final taskName = taskController.text.trim();
                if (taskName.isNotEmpty) {
                  setState(() {
                    tasks.add(Task(name: taskName));
                    saveTasks(); // Save tasks after adding a new task
                  });
                  Navigator.pop(context);
                } else {
                  showErrorDialog('Task name cannot be empty');
                }
              },
              child: Text(
                'Add',
                style: GoogleFonts.poppins(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      tasks[index].isCompleted = value ?? false;
      saveTasks(); // Save tasks after marking a task as complete/incomplete
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      saveTasks(); // Save tasks after deleting a task
    });
  }

  void toggleDayNightMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(theme.textTheme),
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          title: Text(
            'DO-LIST',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: toggleDayNightMode,
                icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.brightness_4),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 5,
          onPressed: createNewTask,
          child: const Icon(Icons.add),
        ),
        body: tasks.isEmpty
            ? Center(
          child: Text(
            'No tasks right now',
            style: GoogleFonts.poppins(
              color: Colors.grey,
            ),
          ),
        )
            : ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Dismissible(
              key: Key(task.name),
              onDismissed: (_) {
                deleteTask(index);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: TaskTile(
                task: task,
                onChanged: (value) => checkBoxChanged(value, index),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Task {
  final String name;
  bool isCompleted;

  Task({required this.name, this.isCompleted = false});
}

class TaskTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;

  const TaskTile({
    Key? key,
    required this.task,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: onChanged,
        ),
        title: Text(
          task.name,
          style: GoogleFonts.poppins(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}