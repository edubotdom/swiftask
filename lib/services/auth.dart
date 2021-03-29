import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SingIn as Anonymous
  Future signInAsAnonymous() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // SignIn with Email and Password

  // Register with Email and Password

  // SignOut
}
