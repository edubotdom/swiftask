import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String _uid;

  MyUser(this._uid);

  MyUser.map(DocumentSnapshot obj) {
    this._uid = obj.get('uid');
  }

  String get uid => this._uid;

  @override
  String toString() => 'Task<$uid>';
}
