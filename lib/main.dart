import 'package:coffre_app/modules/rating.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/Wrapper.dart';
import 'package:coffre_app/pages/authenricate/register%20worker.dart';
import 'package:coffre_app/pages/authenricate/register.dart';
import 'package:coffre_app/pages/authenricate/sign_in.dart';
import 'package:coffre_app/pages/home/Customer/Accepted_req_list.dart';
import 'package:coffre_app/pages/home/Customer/Cust_orders.dart';
import 'package:coffre_app/pages/home/Customer/accepted_reqs.dart';
import 'package:coffre_app/pages/home/Customer/cust_home.dart';
import 'package:coffre_app/pages/home/Customer/orderPage.dart';
import 'package:coffre_app/pages/home/LandingPage.dart';
import 'package:coffre_app/pages/home/Shop/shopHomePage.dart';
import 'package:coffre_app/pages/home/Worker/OrdersMap.dart';
import 'package:coffre_app/pages/home/Worker/Track_accept.dart';
import 'package:coffre_app/pages/home/Worker/miniMap.dart';
import 'package:coffre_app/pages/home/Worker/show_request.dart';
import 'package:coffre_app/pages/home/Worker/workerLocation.dart';
import 'package:coffre_app/pages/home/Worker/workerProfile.dart';
import 'package:coffre_app/pages/home/Worker/worker_home.dart';

import 'package:coffre_app/pages/home/Worker/worker_requests.dart';

// import 'package:coffre_app/pages/home/cust_home.dart';
import 'package:coffre_app/pages/home/Customer/profile.dart';

import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/feedbacks.dart';
import 'package:coffre_app/shared/feedbacks2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
            initialData: null, value: AuthSrrvice().user),
        StreamProvider<List<UserData>?>.value(
            initialData: [], value: DatabaseService().users2),
        StreamProvider<List<WorkingOnit>>.value(
            initialData: [], value: DatabaseService().WorkingOnitStream),
        StreamProvider<List<AcceptedRequest>>.value(
            initialData: [], value: DatabaseService().Acceptedrequets),
        StreamProvider<List<Request>>.value(
            initialData: [], value: DatabaseService().requets),
        StreamProvider<List<Rate>>.value(
            initialData: [], value: DatabaseService().ratee),
      ],
      child: OverlaySupport.global(
        child: MaterialApp(
          supportedLocales: L10n.all,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          debugShowCheckedModeBanner: false,
          routes: {
            '/cust_orders': (context) => Cust_Order(),
            '/cust_home': (context) => Cust_Home(),
            '/login': (context) => SignIn(),
            '/Register': (context) => Register(),
            '/RegisterWorker': (context) => RegisterWorker(),
            '/worker_home': (context) => worker_home(),
            '/worker_requests': (context) => worker_requests(),
            '/cust_ordering': (context) => OrderPage(),
            '/Show_Request': (context) => ShowRequest(),
            '/Accepted_Requests': (context) => Accepted_Orders(),
            '/SetWorkerLocation': (context) => setLocationWorker(),
            '/accept_tracker': (context) => accept_tracker(),
            '/Profile': (context) => Profile(),
            '/OrdersMap': (context) => OrdersMap(),
            '/mini_Map': (context) => miniMap(),
            '/FeedBack': (context) => FeedBack(),
            '/FeedBack2': (context) => FeedBack2(),
            '/LandingPage': (context) => LandingPage(),
          },
          home: Wrapper(),
        ),
      ),
    );
  }
}
