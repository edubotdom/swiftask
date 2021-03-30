import 'package:flutter/material.dart';
import 'package:swiftask/models/user.dart';
import 'package:swiftask/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Registrarse'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text('Iniciar sesión'),
            style: ButtonStyle(
                foregroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.yellow[300])),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'El email es obligatorio';
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'El email introducido no es válido';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() => this.email = value);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => value.length < 8
                    ? 'La contraseña debe tener al menos 8 caracteres'
                    : null,
                onChanged: (value) {
                  setState(() => this.password = value);
                },
              ),
              SizedBox(
                height: 40.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (_formKey.currentState.validate()) {
                      MyUser result = await _auth.registerWithEmailAndPassword(
                          email, password);

                      if (result != null) {
                        print('Signed in as: ' + result.uid);
                      } else {
                        _formKey.currentState.reset();
                        print('Error signing in');
                      }
                    }
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.red)),
                child: Text(
                  'Registrarse',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
