import 'package:coffre_app/modules/user.dart';
import 'package:coffre_app/pages/Wrapper.dart';
import 'package:coffre_app/pages/home/home.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthSrrvice().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
