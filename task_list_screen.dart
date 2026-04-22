import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [
    Task(
      id: "1",
      title: "Підготувати звіт",
      description: "Зробити квартальний звіт",
      isCompleted: false,
      createdAt: DateTime.now(),
      category: "Робота",
      priority: "Високий",
    ),
    Task(
      id: "2",
      title: "Купити продукти",
      description: "Молоко, хліб, яйця",
      isCompleted: true,
      createdAt: DateTime.now(),
      category: "Покупки",
      priority: "Середній",
    ),
  ];

  Future<void> _addTask() async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );

    if (newTask != null) {
      setState(() => tasks.add(newTask));
    }
  }

  Future<void> _openTask(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(task: task),
      ),
    );

    if (result == "delete") {
      setState(() {
        tasks.removeWhere((t) => t.id == task.id);
      });
    } else if (result is Task) {
      setState(() {
        final index = tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          tasks[index] = result;
        }
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day}.${date.month}.${date.year}";
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Робота":
        return Icons.work;
      case "Особисте":
        return Icons.person;
      case "Навчання":
        return Icons.school;
      case "Покупки":
        return Icons.shopping_cart;
      default:
        return Icons.task;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мої завдання'),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(child: Text("Немає завдань"))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Card(
                  child: ListTile(
                    onTap: () => _openTask(task),
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        setState(() {
                          task.isCompleted = value!;
                        });
                      },
                    ),
                    title: Text(task.title),
                    subtitle: Text("Створено: ${_formatDate(task.createdAt)}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getCategoryIcon(task.category)),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
