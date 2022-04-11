import 'package:coffre_app/pages/Wrapper.dart';
import 'package:coffre_app/pages/authenricate/sign_in.dart';
import 'package:coffre_app/pages/home/Customer/Cust_orders.dart';
import 'package:coffre_app/pages/home/Customer/cust_home.dart';
import 'package:coffre_app/pages/home/Customer/orderPage.dart';
import 'package:coffre_app/pages/home/Worker/show_request.dart';
import 'package:coffre_app/pages/home/Worker/worker_home.dart';
import 'package:coffre_app/pages/home/Worker/worker_requests.dart';

// import 'package:coffre_app/pages/home/cust_home.dart';
import 'package:coffre_app/pages/home/profile.dart';
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
        routes: {
          '/cust_orders': (context) => Cust_Order(),
          '/cust_home': (context) => Cust_Home(),
          '/login': (context) => SignIn(),
          '/worker_home': (context) => worker_home(),
          '/worker_requests': (context) => worker_requests(),
          '/cust_ordering': (context) => OrderPage(),
          '/Show_Request': (context) => ShowRequest(),
        },
        home: Wrapper(),
      ),
    );
  }
}
