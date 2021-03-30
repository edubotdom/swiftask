import 'package:flutter/material.dart';
import 'package:swiftask/models/user.dart';
import 'package:swiftask/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final _fieldEmail = TextEditingController();
  final _fieldPassword = TextEditingController();

  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Iniciar sesión'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text('Registrarse'),
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
                controller: _fieldEmail,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => value.length < 8
                    ? 'La contraseña debe tener al menos 8 caracteres'
                    : null,
                controller: _fieldPassword,
              ),
              SizedBox(
                height: 40.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    MyUser result = await _auth.signInWithEmailAndPassword(
                        _fieldEmail.text, _fieldPassword.text);

                    if (result != null) {
                      print('Signed in as: ' + result.uid);
                    } else {
                      _fieldPassword.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('El email o la contraseña es incorrecta'),
                          backgroundColor: Colors.red[300],
                        ),
                      );

                      print('Error signing in');
                    }
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.red)),
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    MyUser result = await _auth.signInAsAnonymous();

                    if (result != null) {
                      print('Signed in as: ' + result.uid);
                    } else {
                      print('Error signing in');
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.deepPurple[300])),
                  child: Text(
                    'Iniciar sesión anónimamente',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
