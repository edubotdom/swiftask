import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiftask/models/task.dart';
import 'package:swiftask/models/user.dart';
import 'package:swiftask/services/data_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskForm extends StatefulWidget {
  Task initialTask;

  TaskForm({this.initialTask});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";
  String status = "TO DO";

  @override
  void initState() {
    super.initState();

    if (widget.initialTask != null) {
      print('hi 2');
      this.title = widget.initialTask.title;
      this.description = widget.initialTask.description;
      this.status = widget.initialTask.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('hi');
    final user = Provider.of<MyUser>(context);
    DataRepository repository = DataRepository(uid: user.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva tarea"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: this.title,
                      decoration: InputDecoration(labelText: 'Título'),
                      onChanged: (value) => this.title = value,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: this.description,
                      keyboardType: TextInputType.multiline,
                      minLines: 4,
                      maxLines: 6,
                      decoration: InputDecoration(labelText: 'Descripción'),
                      onChanged: (value) => this.description = value,
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    SizedBox(height: 20.0),
                    widget.initialTask == null
                        ? ElevatedButton(
                            onPressed: () async {
                              Task newTask = Task(title, status, description);
                              repository.createNewTask(newTask);
                              Navigator.pop(context);
                            },
                            child: Text('Crear tarea'),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              Task newTask = Task(title, status, description);
                              newTask.reference = widget.initialTask.reference;
                              repository.updateTask(newTask);
                              Navigator.pop(context);
                            },
                            child: Text('Actualizar tarea'),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

Future<DateTime> _pickDateTime(BuildContext context) async {
  DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 30)));

  TimeOfDay t =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());

  if (d != null && t != null) {
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  } else {
    return null;
  }
}

Future<void> _openMap(double latitude, double longitude) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    throw 'Could not open the map.';
  }
}

/*
class TaskForm extends StatefulWidget {
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";
  DateTime pickedStartDate = DateTime.now();
  DateTime pickedEndDate = DateTime.now();
  double latitude = 10.0;
  double longitude = 10.0;

  Future<DateTime> _pickDateTime(BuildContext context) async {
    DateTime d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now().add(Duration(days: 30)));

    TimeOfDay t =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (d != null && t != null) {
      return DateTime(d.year, d.month, d.day, t.hour, t.minute);
    } else {
      return null;
    }
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    final _db = DatabaseService(uid: user.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva tarea"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                onChanged: (value) => this.title = value,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 4,
                maxLines: 6,
                decoration: InputDecoration(labelText: 'Descripción'),
                onChanged: (value) => this.description = value,
              ),
              SizedBox(
                height: 40.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime dateTime = await _pickDateTime(context);
                  setState(() => this.pickedStartDate = dateTime);
                },
                child: Text('Fecha de inicio: ' + pickedStartDate.toString()),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime dateTime = await _pickDateTime(context);
                  setState(() => this.pickedEndDate = dateTime);
                },
                child: Text('Fecha de fin: ' + pickedEndDate.toString()),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Latitud'),
                onChanged: (value) => this.latitude = double.parse(value),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Longitud'),
                onChanged: (value) => this.longitude = double.parse(value),
              ),
              ElevatedButton(
                onPressed: () async {
                  await openMap(this.latitude, this.longitude);
                },
                child: Text('Abrir mapita'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _db.newTask(Task(
                    title: title,
                    description: description,
                    status: 'TO DO',
                    startDate: pickedStartDate,
                    endDate: pickedEndDate,
                    latitude: latitude,
                    longitude: longitude,
                  ));
                },
                child: Text('Crear tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/
