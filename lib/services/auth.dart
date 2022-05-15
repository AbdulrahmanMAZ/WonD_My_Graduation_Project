import 'package:coffre_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthSrrvice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create a user objext based on Firebaseuser
  // UserO? _userFromFirebaseUser(User? user) {
  //   return user != null ? UserO(uid: user.uid) : null;
  // }

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
    // .map((User? user) => _userFromFirebaseUser(user));
    // .map(_userFromFirebaseUser);
  }

  Future signINAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user?.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in wiht e-mail and password.

  Future SignInWithEmailAndPassword(email, password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return user!.uid;
    } catch (e) {
      return null;
    }
  }

  //sign in with google account
  final googleSignIn = GoogleSignIn();

  // Register in with e-maili and passeord.
  Future RegisterWithEmailAndPassword(
      String name,
      String email,
      String password,
      bool isWorker,
      bool isShop,
      String profession,
      String phone_number) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      user!.updateDisplayName(name);
      // if (isWorker) {
      //   DatabaseService()
      //       .WorkersCollection
      //       .doc()
      //       .set({'Worker_ID': user.uid, 'Worker_email': email});
      // }
      await DatabaseService(uid: user.uid).updateUserData(
          name, isWorker, isShop, email, profession, phone_number);
      return user;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }
  //sigh out

  Future SignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  String inputData() {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    return uid;
  }
}
