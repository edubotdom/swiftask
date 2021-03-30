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

  String email = '';
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
                validator: (value) =>
                    value.isEmpty ? 'El email es obligatorio' : null,
                onChanged: (value) {
                  setState(() => this.email = value);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
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
                    MyUser result =
                        await _auth.signInWithEmailAndPassword(email, password);

                    if (result != null) {
                      print('Signed in as: ' + result.uid);
                    } else {
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
