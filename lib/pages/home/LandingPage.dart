import 'package:coffre_app/pages/Wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
          text: 'W',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 185, 12, 219)),
          children: [
            TextSpan(
              text: 'on',
              style: TextStyle(
                  color: Color.fromARGB(255, 187, 174, 174), fontSize: 30),
            ),
            TextSpan(
              text: 'D',
              style: TextStyle(
                  color: Color.fromARGB(212, 208, 197, 221), fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    var jcbFont = GoogleFonts.roboto().fontFamily;
    return

        //Create a flutter landing page that has register and login buttons
        Scaffold(
            backgroundColor: Color.fromARGB(255, 169, 140, 175),
            body: Container(
              height: height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color.fromARGB(255, 73, 3, 105),
                    Color.fromARGB(255, 15, 7, 1)
                  ])),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    _title(),
                    // create the app logo
                    Image.asset(
                      'images/path1752.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: height * 0.1),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          primary: Color.fromARGB(108, 139, 5, 139),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/RegisterWorker');
                        },
                        child: Text(
                            AppLocalizations.of(context)!.registerAsWorker)),
                    SizedBox(height: 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          primary: Color.fromARGB(108, 139, 5, 139),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/Register');
                        },
                        child: Text(
                            AppLocalizations.of(context)!.registerAsCustomer)),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        //style eleveted button
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          primary: Color.fromARGB(108, 219, 208, 219),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.login)),
                    SizedBox(height: 20.0)
                  ])),
            ));
  }
}
