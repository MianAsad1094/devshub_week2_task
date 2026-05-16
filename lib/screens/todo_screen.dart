import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Tasks load krna
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks = prefs.getStringList('todo_tasks') ?? [];
    });
  }

  // Naya task add krna (Enhanced with SnackBar)
  Future<void> _addTask() async {
    if (_taskController.text.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks.add(_taskController.text.trim());
      _taskController.clear();
    });
    await prefs.setStringList('todo_tasks', _tasks);

    // Success Notification
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task added successfully!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Naya Feature: Task Delete krna
  Future<void> _deleteTask(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final removedTask = _tasks[index]; // Message dikhane k liye task ka naam save kiya

    setState(() {
      _tasks.removeAt(index);
    });
    await prefs.setStringList('todo_tasks', _tasks);

    // Delete Notification
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted: $removedTask'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My To-Do List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0, // Clean flat look
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Enhanced Input Field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'What needs to be done?',
                      hintText: 'Enter a task...',
                      prefixIcon: const Icon(Icons.edit_note),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15), // Rounded corners
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Icon(Icons.add, size: 28), // Button pr text ki jagah icon
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Enhanced ListView aur Empty State
            Expanded(
              child: _tasks.isEmpty
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.assignment_turned_in_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'All caught up!\nAdd some tasks to get started.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              )
                  : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded Card
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.task, color: Colors.white, size: 20),
                      ),
                      title: Text(
                        _tasks[index],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      // Delete Button Widget
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteTask(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}