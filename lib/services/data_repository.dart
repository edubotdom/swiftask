import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swiftask/models/task.dart';

class DataRepository {
  final String uid;
  DataRepository({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getTaskStreamByStatus(String status) {
    return userCollection
        .doc(this.uid)
        .collection('tasks')
        .where('status', isEqualTo: status)
        //.orderBy('title')
        .snapshots();
  }

  Future<DocumentReference> createNewTask(Task task) {
    return userCollection.doc(this.uid).collection('tasks').add(task.toJson());
  }

  Future<void> updateTask(Task task) {
    return userCollection
        .doc(this.uid)
        .collection('tasks')
        .doc(task.reference.id)
        .update(task.toJson());
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) {
    return userCollection.doc(this.uid).collection('tasks').doc(taskId).update({
      'status': newStatus,
    });
  }

  Future<void> deleteTaskById(String taskId) {
    return userCollection
        .doc(this.uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}
