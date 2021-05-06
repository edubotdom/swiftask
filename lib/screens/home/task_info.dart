import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiftask/models/task.dart';
import 'package:swiftask/models/user.dart';
import 'package:swiftask/screens/home/task_form.dart';
import 'package:swiftask/services/data_repository.dart';

class TaskInfo extends StatefulWidget {
  final Task task;

  TaskInfo({this.task});

  @override
  _TaskInfoState createState() => _TaskInfoState();
}

class _TaskInfoState extends State<TaskInfo> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    DataRepository repository = DataRepository(uid: user.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0))),
              child: Text(
                widget.task.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 8.0)),
            Container(
              padding: EdgeInsets.only(left: 45.0, top: 20.0),
              child: Text(
                'Descripción',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(widget.task.description),
            ),
          ],
        ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            child: FloatingActionButton(
              heroTag: 'editBtn',
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TaskForm(initialTask: widget.task)));
              },
              backgroundColor: Colors.green,
              child: Icon(Icons.edit),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: FloatingActionButton(
              heroTag: 'deleteBtn',
              onPressed: () {
                repository.deleteTaskById(widget.task.reference.id);
                Navigator.pop(context);
              },
              backgroundColor: Colors.red,
              child: Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _chooseIcon(String type) {
  switch (type) {
    case 'IN PROGRESS':
      return Icon(
        Icons.pending_rounded,
        color: Colors.indigoAccent,
      );
    case 'DONE':
      return Icon(
        Icons.done_sharp,
        color: Colors.green,
      );
    default:
      return Icon(
        Icons.pending_actions_sharp,
        color: Colors.blueGrey,
      );
  }
}
