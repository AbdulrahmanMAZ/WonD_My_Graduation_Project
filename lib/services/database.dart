import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:coffre_app/modules/User.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/modules/requests.dart';
//import 'package:coffre_app/modules/user.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference workersCollection =
      FirebaseFirestore.instance.collection('coffes');

  final CollectionReference RequestsCollection =
      FirebaseFirestore.instance.collection('requests');

  final CollectionReference WorkersCollection =
      FirebaseFirestore.instance.collection('Collection of workers');

  Future<void> updateUserData(String name, bool isWorker) async {
    return await workersCollection.doc(uid).set({
      'name': name,
      'isWorker': isWorker,
    });
  }

  Future<void> RaiseRequest(String name, String Cust_ID, int t) async {
    return await RequestsCollection.doc(Cust_ID)
        .set({'Cust_ID': Cust_ID, 'name': name, 'time': t});
  }

  List<Request> _requestsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return Request(
          name: doc.get('name'),
          Cust_ID: doc.get('Cust_ID'),
          t: doc.get('time'));
    }).toList();
  }

  List<Request> _userRequestsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Request(
          name: doc.get('name'),
          Cust_ID: doc.get('Cust_ID'),
          t: doc.get('time'));
    }).toList();
  }

  // brew list from snapshot
  List<user> _workersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return user(
          name: doc.get('name') ?? '', isWorker: doc.get('isWorker') ?? false);
    }).toList();
  }

  //UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.get('name'),
        isWorker: snapshot.get('isWorker'));
  }

  //get users stream
  Stream<List<user>> get users {
    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return workersCollection.snapshots().map(_workersListFromSnapshot);
  }

  Stream<List<Request>> get requets {
    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return RequestsCollection.snapshots().map(_requestsListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return workersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // Stream<UserData> get userData {
  //   return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  // }
}
