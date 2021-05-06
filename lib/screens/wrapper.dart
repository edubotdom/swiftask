import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiftask/models/user.dart';
import 'package:swiftask/screens/authenticate/authenticate.dart';
import 'package:swiftask/screens/home/home.dart';
import 'package:swiftask/screens/home/task_list.dart';

import '../main.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    print('Wrapper has: ' + user.toString());

    return user != null ? Home() : Authenticate();
  }
}
