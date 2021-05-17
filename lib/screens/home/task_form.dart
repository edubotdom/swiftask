import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiftask/models/task.dart';
import 'package:swiftask/models/user.dart';
import 'package:swiftask/services/data_repository.dart';
import 'package:intl/intl.dart';

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

  DateTime taskStartDateTime = DateTime.now();
  DateTime taskEndDateTime = DateTime.now();
  DateTime createDate = DateTime.now();

  TextEditingController _dateController;
  TextEditingController _startTimeController;
  TextEditingController _endTimeController;

  @override
  void initState() {
    super.initState();

    if (widget.initialTask != null) {
      this.title = widget.initialTask.title;
      this.description = widget.initialTask.description;
      this.status = widget.initialTask.status;

      if (this.createDate == null ||
          this.taskStartDateTime == null ||
          this.taskStartDateTime == null) {
        taskStartDateTime = DateTime.now();
        taskEndDateTime = DateTime.now();
        createDate = DateTime.now();
      } else {
        this.createDate = widget.initialTask.createDate.toDate();
        this.taskStartDateTime = widget.initialTask.taskStartDateTime.toDate();
        this.taskEndDateTime = widget.initialTask.taskEndDateTime.toDate();
      }
    }

    _dateController = TextEditingController(
        text: DateFormat("yyyy-MM-dd").format(taskStartDateTime));
    _startTimeController = TextEditingController(
        text: DateFormat('kk:mm').format(taskStartDateTime));
    _endTimeController = TextEditingController(
        text: DateFormat('kk:mm').format(taskEndDateTime));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    DataRepository repository = DataRepository(uid: user.uid);

    final createOrUpdateButton = widget.initialTask == null
        ? ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.greenAccent.shade700)),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                Task newTask = Task(
                    title,
                    status,
                    description,
                    Timestamp.fromDate(createDate),
                    Timestamp.fromDate(taskStartDateTime),
                    Timestamp.fromDate(taskEndDateTime));
                repository.createNewTask(newTask);
                Navigator.pop(context);
              }
            },
            child: Text('Crear tarea'),
          )
        : ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.greenAccent.shade700)),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                Task newTask = Task(
                    title,
                    status,
                    description,
                    Timestamp.fromDate(createDate),
                    Timestamp.fromDate(taskStartDateTime),
                    Timestamp.fromDate(taskEndDateTime));
                newTask.reference = widget.initialTask.reference;
                repository.updateTask(newTask);
                Navigator.pop(context);
              }
            },
            child: Text('Actualizar tarea'),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.initialTask == null ? "Nueva tarea" : "Actualizar tarea"),
        backgroundColor: Colors.green.shade900,
      ),
      body: Column(
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
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'El título es obligatorio';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: this.description,
                      keyboardType: TextInputType.multiline,
                      minLines: 4,
                      maxLines: 6,
                      decoration: InputDecoration(labelText: 'Descripción'),
                      onChanged: (value) => this.description = value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'La descripción es obligatoria';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 40.0),
                    TextFormField(
                      controller: _dateController,
                      onTap: () async {
                        DateTime d =
                            await _pickDate(context, taskStartDateTime);

                        setState(() {
                          taskStartDateTime = DateTime(d.year, d.month, d.day,
                              taskStartDateTime.hour, taskStartDateTime.minute);

                          taskEndDateTime = DateTime(d.year, d.month, d.day,
                              taskEndDateTime.hour, taskEndDateTime.minute);

                          _dateController.value = TextEditingValue(
                              text: DateFormat("yyyy-MM-dd")
                                  .format(taskStartDateTime));
                        });
                      },
                      showCursor: false,
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                          labelText: 'Fecha',
                          suffix: Icon(
                            Icons.arrow_drop_down_circle_outlined,
                            size: 20,
                          )),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: _startTimeController,
                            onTap: () async {
                              TimeOfDay t = await _pickTime(context,
                                  TimeOfDay.fromDateTime(taskStartDateTime));

                              setState(() {
                                taskStartDateTime = DateTime(
                                    taskStartDateTime.year,
                                    taskStartDateTime.month,
                                    taskStartDateTime.day,
                                    t.hour,
                                    t.minute);

                                _startTimeController.value = TextEditingValue(
                                    text: DateFormat('kk:mm')
                                        .format(taskStartDateTime));
                              });
                            },
                            showCursor: false,
                            readOnly: true,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                                labelText: 'Hora de inicio',
                                suffix: Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  size: 20,
                                )),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Flexible(
                          child: TextFormField(
                            controller: _endTimeController,
                            onTap: () async {
                              TimeOfDay t = await _pickTime(context,
                                  TimeOfDay.fromDateTime(taskEndDateTime));

                              setState(() {
                                taskEndDateTime = DateTime(
                                    taskEndDateTime.year,
                                    taskEndDateTime.month,
                                    taskEndDateTime.day,
                                    t.hour,
                                    t.minute);

                                _endTimeController.value = TextEditingValue(
                                    text: DateFormat('kk:mm')
                                        .format(taskEndDateTime));
                              });
                            },
                            showCursor: false,
                            readOnly: true,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              labelText: 'Hora de fin',
                              suffix: Icon(
                                Icons.arrow_drop_down_circle_outlined,
                                size: 20,
                              ),
                              errorMaxLines: 8,
                            ),
                            validator: (value) {
                              if (taskEndDateTime.isBefore(taskStartDateTime)) {
                                return 'La hora de fin debe ser posterior o igual a la hora de inicio';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    createOrUpdateButton,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<DateTime> _pickDate(BuildContext context, DateTime date) async {
  DateTime d = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: date.subtract(Duration(days: 30)),
      lastDate: date.add(Duration(days: 30)));

  return d;
}

Future<TimeOfDay> _pickTime(BuildContext context, TimeOfDay time) async {
  TimeOfDay t = await showTimePicker(context: context, initialTime: time);

  return t;
}
