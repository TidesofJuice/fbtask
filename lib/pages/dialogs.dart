import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task_service.dart';

class AddTaskDialog extends StatefulWidget {
  final TaskService taskService;

  AddTaskDialog(this.taskService);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Имя'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Описание'),
          ),
          Row(
            children: [
              Text(selectedDate == null
                  ? 'Выберите дату:'
                  : 'Дата: ${selectedDate.toString().split(' ')[0]}'),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final description = descriptionController.text.trim();
            final currentUser = FirebaseAuth.instance.currentUser;

            if (name.isNotEmpty && currentUser != null) {
              widget.taskService.addTask({
                'name': name,
                'description': description,
                'isDone': false,
                'createdBy': currentUser.uid,
                'dueDate': selectedDate?.toIso8601String(),
              });
              Navigator.of(context).pop();
            }
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}

class DeleteTaskDialog extends StatelessWidget {
  final TaskService taskService;
  final String taskId;

  DeleteTaskDialog(this.taskService, this.taskId);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Удалить задачу?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            taskService.deleteTask(taskId);
            Navigator.of(context).pop();
          },
          child: const Text('Удалить'),
        ),
      ],
    );
  }
}
