import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreModel {
  String name;
  String email;
  FieldValue timestamp;

  FireStoreModel({
    required this.name,
    required this.email,
    required this.timestamp,
  });
}
