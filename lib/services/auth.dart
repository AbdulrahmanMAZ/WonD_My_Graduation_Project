import 'package:coffre_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthSrrvice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
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
      String profession,
      String phone_number) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      await user!.updateDisplayName(name);

      await DatabaseService(uid: user.uid)
          .updateUserData(name, isWorker, email, profession, phone_number);
      return user;
    } catch (e) {
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
