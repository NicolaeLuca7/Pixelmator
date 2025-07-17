import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Entity {
  String? _id;

  void setId(String id) {
    this._id = id;
  }

  String getId() {
    return _id.toString();
  }

  Map<String, dynamic> toJson() => {};

  static fromJson(Map<dynamic, dynamic> v) {}
}
