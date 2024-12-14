import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Stream<QuerySnapshot> getTasksStream(String? userId) {
    return tasksCollection.where('createdBy', isEqualTo: userId).snapshots();
  }

  Future<void> updateTaskStatus(String taskId, bool isDone) {
    return tasksCollection.doc(taskId).update({'isDone': isDone});
  }

  Future<void> addTask(Map<String, dynamic> taskData) {
    return tasksCollection.add(taskData);
  }

  Future<void> deleteTask(String taskId) {
    return tasksCollection.doc(taskId).delete();
  }
}
