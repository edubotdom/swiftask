import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiftask/models/task.dart';
import 'package:swiftask/models/user.dart';
import 'package:swiftask/screens/home/task_form.dart';
import 'package:swiftask/services/data_repository.dart';
import 'package:intl/intl.dart';

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

    final taskTitle = Container(
      padding: EdgeInsets.all(25.0),
      decoration: BoxDecoration(
          color: Colors.green.shade800,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0))),
      child: Center(
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
    );

    final editButton = Container(
      margin: EdgeInsets.all(10.0),
      child: FloatingActionButton(
        heroTag: 'editBtn',
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskForm(initialTask: widget.task)));
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.edit),
      ),
    );

    final deleteButton = Container(
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
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles'),
        backgroundColor: Colors.green.shade900,
      ),
      body: SafeArea(
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            taskTitle,
            Container(
              padding: EdgeInsets.only(left: 45.0, top: 45.0),
              child: Text(
                'Descripción',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              margin: EdgeInsets.all(10.0),
              elevation: 8,
              color: Colors.green.shade100,
              child: Container(
                padding: EdgeInsets.all(20.0),
                width: double.infinity,
                child: Text(widget.task.description),
              ),
            ),
            SizedBox(height: 25.0),
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
                    width: double.infinity,
                    child: Text('Fecha',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                ),
                Flexible(
                  child: Card(
                    margin: EdgeInsets.all(10.0),
                    elevation: 8,
                    color: Colors.green.shade100,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      width: double.infinity,
                      child: Text(DateFormat("yyyy-MM-dd")
                          .format(widget.task.taskStartDateTime.toDate())),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
                    width: double.infinity,
                    child: Text('Hora de inicio',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
                    width: double.infinity,
                    child: Text('Hora de fin',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Card(
                    margin: EdgeInsets.all(10.0),
                    elevation: 8,
                    color: Colors.green.shade100,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      width: double.infinity,
                      child: Text(DateFormat('kk:mm')
                          .format(widget.task.taskStartDateTime.toDate())),
                    ),
                  ),
                ),
                Flexible(
                  child: Card(
                    margin: EdgeInsets.all(10.0),
                    elevation: 8,
                    color: Colors.green.shade100,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      width: double.infinity,
                      child: Text(DateFormat('kk:mm')
                          .format(widget.task.taskEndDateTime.toDate())),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 200.0),
          ],
        ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          editButton,
          deleteButton,
        ],
      ),
    );
  }
}
