import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String title;
  String status;
  String description;

  DocumentReference reference;

  Task(this.title, this.status, this.description);

  factory Task.fromSnapshot(DocumentSnapshot snapshot) {
    Task newTask = Task.fromJson(snapshot.data());
    newTask.reference = snapshot.reference;
    return newTask;
  }

  factory Task.fromJson(Map<String, dynamic> json) => _taskFromJson(json);

  Map<String, dynamic> toJson() => _taskToJson(this);

  @override
  String toString() => 'Task<$title>';
}

Task _taskFromJson(Map<String, dynamic> json) {
  return Task(
    json['title'] as String,
    json['status'] as String,
    json['description'] as String,
  );
}

Map<String, dynamic> _taskToJson(Task task) => <String, dynamic>{
      'title': task.title,
      'status': task.status,
      'description': task.description,
    };
