import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreModel {
  String name;
  String email;
  String token;
  FieldValue timestamp;

  FireStoreModel({
    required this.name,
    required this.email,
    required this.timestamp,
    required this.token,
  });
}
