import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String name;
  final String Cust_ID;
  final int t;

  Request({required this.name, required this.Cust_ID, required this.t});
}
