import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String title;
  String status;
  String description;

  Timestamp taskStartDateTime;
  Timestamp taskEndDateTime;
  Timestamp createDate;

  DocumentReference reference;

  Task(this.title, this.status, this.description, this.createDate,
      this.taskStartDateTime, this.taskEndDateTime);

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
    json['createDate'] as Timestamp,
    json['taskStartDateTime'] as Timestamp,
    json['taskEndDateTime'] as Timestamp,
  );
}

Map<String, dynamic> _taskToJson(Task task) => <String, dynamic>{
      'title': task.title,
      'status': task.status,
      'description': task.description,
      'createDate': task.createDate,
      'taskStartDateTime': task.taskStartDateTime,
      'taskEndDateTime': task.taskEndDateTime,
    };
