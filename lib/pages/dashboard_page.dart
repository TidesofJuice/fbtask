import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_service.dart';
import 'dialogs.dart';

class DashboardPage extends StatelessWidget {
  final TaskService _taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _taskService.getTasksStream(currentUser?.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Задачи не найдены'));
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final taskData = task.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(
                  taskData['name'] ?? 'Нет названия',
                  style: TextStyle(
                    decoration: taskData['isDone']
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(taskData['description'] ?? 'Нет описания'),
                    if (taskData['dueDate'] != null)
                      Text('Дата: ${taskData['dueDate'].split('T')[0]}'),
                  ],
                ),
                trailing: Checkbox(
                  value: taskData['isDone'] ?? false,
                  onChanged: (value) {
                    _taskService.updateTaskStatus(task.id, value ?? false);
                  },
                ),
                onLongPress: () {
                  _showDeleteConfirmationDialog(context, task.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(_taskService),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (context) => DeleteTaskDialog(_taskService, taskId),
    );
  }
}
