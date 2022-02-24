import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/coffe.dart';
import 'package:coffre_app/modules/user.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('coffes');

  Future<void> updateUserData(String sugars, String name, int strentgh) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strentgh': strentgh,
    });
  }

  // brew list from snapshot
  List<Coffe> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return Coffe(
          name: doc.get('name') ?? '',
          strentgh: doc.get('strentgh') ?? 0,
          sugars: doc.get('sugars') ?? '0');
    }).toList();
  }

  //UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.get('name'),
        strngth: snapshot.get('strentgh'),
        sugars: snapshot.get('sugars'));
  }

  //get brews stream
  Stream<List<Coffe>> get brews {
    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
