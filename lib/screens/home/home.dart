import 'package:flutter/material.dart';
import 'package:swiftask/screens/home/task_form.dart';
// import 'package:swiftask/screens/home/task_form.dart';
import 'package:swiftask/screens/home/task_list.dart';
import 'package:swiftask/services/auth.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lista de tareas'),
          backgroundColor: Colors.green.shade900,
          actions: <Widget>[
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('Cerrar sesión'),
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
              ),
            ),
          ],
          bottom: TabBar(isScrollable: true, tabs: <Widget>[
            Tab(
              child: Row(children: <Widget>[
                Icon(
                  Icons.pending_actions_sharp,
                  size: 15.0,
                ),
                Text(
                  ' Por hacer',
                  style: TextStyle(fontSize: 15.0),
                )
              ]),
            ),
            Tab(
              child: Row(children: <Widget>[
                Icon(
                  Icons.pending,
                  size: 15.0,
                ),
                Text(
                  ' En progreso',
                  style: TextStyle(fontSize: 15.0),
                )
              ]),
            ),
            Tab(
              child: Row(children: <Widget>[
                Icon(
                  Icons.done_all_sharp,
                  size: 15.0,
                ),
                Text(
                  ' Hecho',
                  style: TextStyle(fontSize: 15.0),
                )
              ]),
            ),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            TaskList(type: 'TO DO'),
            TaskList(type: 'IN PROGRESS'),
            TaskList(type: 'DONE'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TaskForm()));
          },
          backgroundColor: Colors.orange,
        ),
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {
          print('Pressed: New Form button');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TaskForm()));
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Welcome'),
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(Icons.person),
            label: Text('Sign Out'),
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  */
}
