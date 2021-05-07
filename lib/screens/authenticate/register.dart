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
    final emailField = TextFormField(
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
    );

    final passwordField = TextFormField(
      decoration: InputDecoration(labelText: 'Contraseña'),
      obscureText: true,
      validator: (value) => value.length < 8
          ? 'La contraseña debe tener al menos 8 caracteres'
          : null,
      onChanged: (value) {
        setState(() => this.password = value);
      },
    );

    final signUpButton = ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          if (_formKey.currentState.validate()) {
            MyUser result =
                await _auth.registerWithEmailAndPassword(email, password);

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
          backgroundColor: MaterialStateColor.resolveWith(
              (states) => Colors.greenAccent.shade700)),
      child: Text(
        'Registrarse',
        style: TextStyle(color: Colors.white),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
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
                    (states) => Colors.amber.shade300)),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Bienvenido/a a SwifTask',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                height: 100.0,
                child: Image.asset(
                  'assets/images/book_icon.png',
                ),
              ),
              emailField,
              SizedBox(height: 20.0),
              passwordField,
              SizedBox(
                height: 40.0,
              ),
              signUpButton,
            ],
          ),
        ),
      ),
    );
  }
}
