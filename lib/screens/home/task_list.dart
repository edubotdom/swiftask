import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiftask/models/task.dart';
import 'package:swiftask/models/user.dart';
import 'package:swiftask/screens/home/task_info.dart';
import 'package:swiftask/services/data_repository.dart';

class TaskList extends StatefulWidget {
  final String type;
  TaskList({this.type});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    print(user.uid);
    DataRepository repository = DataRepository(uid: user.uid);
    List<Task> tasks;

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: repository.getTaskStreamByStatus(widget.type),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            tasks =
                /* [
              Task('Titulo de la tarea toa toa ot wef wef wefa', 'TO DO',
                  'descripcion muy muy efijwef weofijwef oj wefij wfowejfio woefijweofij wefwe ef wef wef wef fwefg wefwe wef fwewe weff fwgwef ')
            ];*/
                snapshot.data.docs.map((e) => Task.fromSnapshot(e)).toList();

            print(tasks);
            return Center(
              child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, position) {
                    return Column(
                      children: <Widget>[
                        Divider(
                          height: 7.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                title: Text(tasks[position].title),
                                // subtitle: Text(tasks[position].description),
                                leading: Center(
                                    widthFactor: 1,
                                    child: _chooseIcon(widget.type)),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TaskInfo(task: tasks[position])));
                                },
                              ),
                            ),
                            widget.type != 'TO DO'
                                ? IconButton(
                                    icon: Icon(Icons.arrow_left_sharp,
                                        color: Colors.green),
                                    onPressed: () {
                                      switch (widget.type) {
                                        case 'IN PROGRESS':
                                          repository.updateTaskStatus(
                                              tasks[position].reference.id,
                                              'TO DO');
                                          break;
                                        case 'TO DO':
                                          repository.updateTaskStatus(
                                              tasks[position].reference.id,
                                              'IN PROGRESS');
                                          break;
                                      }
                                    })
                                : Container(),
                            widget.type != 'DONE'
                                ? IconButton(
                                    icon: Icon(Icons.arrow_right_sharp,
                                        color: Colors.green),
                                    onPressed: () {
                                      switch (widget.type) {
                                        case 'TO DO':
                                          repository.updateTaskStatus(
                                              tasks[position].reference.id,
                                              'IN PROGRESS');
                                          break;
                                        case 'IN PROGRESS':
                                          repository.updateTaskStatus(
                                              tasks[position].reference.id,
                                              'DONE');
                                          break;
                                      }
                                    })
                                : Container(),
                          ],
                        ),
                      ],
                    );
                  }),
            );
          }),
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
/*
class TaskList extends StatefulWidget {
  final String type;
  TaskList({this.type});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks;
  MyUser user;
  DataRepository repository;

  @override
  void initState() {
    super.initState();

    /*[
      Task('Tarea 1', 'TO DO', 'Descripción de la tarea 1'),
      Task('Tarea 2', 'TO DO', 'Descripción de la tarea 2'),
      Task('Tarea 3', 'TO DO', 'Descripción de la tarea 3'),
    ];*/
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser>(context);
    repository = DataRepository(uid: user.uid);

    this.tasks = repository
        .getStream()
        .map((DocumentSnapshot snapshot) => Task.fromSnapshot(snapshot))
        .toList();

    return Container(
      child: Center(
        child: ListView.builder(
            itemCount: this.tasks.length,
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  Divider(
                    height: 7.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text(this.tasks[position].title),
                          subtitle: Text(this.tasks[position].description),
                          leading: Center(
                              widthFactor: 1, child: _chooseIcon(widget.type)),
                          onTap: () => print('Tap on item $position'),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => print('Delete item $position')),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
*/
