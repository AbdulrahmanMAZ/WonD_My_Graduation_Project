import 'dart:convert';
import 'dart:math';
import 'package:coffre_app/pages/authenricate/register.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:coffre_app/pages/authenricate/authenticate.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignIn extends StatefulWidget {
  // const SignIn({Key? key}) : super(key: key);

  final Function? toggleVeiw;
  SignIn({this.toggleVeiw});

  @override
  _SignInState createState() => _SignInState();
}

final _formKey = GlobalKey<FormState>();
AuthSrrvice _auth = AuthSrrvice();
//Text field state
String email = '';
String password = '';
String error = '';
bool? _passwordVisible = true;

class _SignInState extends State<SignIn> {
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
  }

  Autheticate a = new Autheticate();

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        widget.toggleVeiw!();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.gotoregisterNOAccount,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              AppLocalizations.of(context)!.register,
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
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
                child: Stack(
                  children: [
                    PositionedBackground(context),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                        reverse: false,
                        child: Stack(
                          children: [
                            Container(
                              // padding:
                              //     EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.welcome,
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontFamily: Constants.appFont,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .grettingParagrath,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: Constants.appFont,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      // E-Mail text field
                                      const SizedBox(height: 15),
                                      TextFormField(
                                          key: Key('username'),
                                          restorationId: '1',
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  labelText:
                                                      AppLocalizations.of(
                                                              context)!
                                                          .enterEmail,
                                                  hintText: AppLocalizations.of(
                                                          context)!
                                                      .enterEmail),
                                          validator: (val) => val!.isEmpty
                                              ? AppLocalizations.of(context)!
                                                  .enterEmail
                                              : null,
                                          onChanged: (val) {
                                            setState(() {
                                              email = val;
                                            });
                                          }),
                                      SizedBox(
                                        height: 20,
                                      ),

                                      //Password text field
                                      TextFormField(
                                        key: Key('password'),
                                        decoration:
                                            passwordInputDecoration.copyWith(
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .enterPass,
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .enterPass,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible!;
                                              });
                                            },
                                            icon: Icon(_passwordVisible!
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                          ),
                                        ),
                                        validator: (val) => val!.length < 8
                                            ? AppLocalizations.of(context)!
                                                .shorPass
                                            : null,
                                        obscureText: _passwordVisible!,
                                        onChanged: (val) {
                                          setState(() {
                                            password = val;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),

                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          key: Key('submit'),
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size.fromHeight(50),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            primary:
                                                Color.fromARGB(110, 0, 0, 0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                loading = true;
                                                error = '';
                                              });
                                              dynamic result = await _auth
                                                  .SignInWithEmailAndPassword(
                                                      email, password);

                                              if (result == null) {
                                                setState(() {
                                                  error = AppLocalizations.of(
                                                          context)!
                                                      .incorrectInfo;
                                                  loading = false;
                                                });
                                              }
                                              //   if (result != null) {
                                              //     setState(() {
                                              //       error = 'Incorrect information';
                                              //       loading = false;
                                              //     });
                                              //   }
                                            }
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .loginButton,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontFamily: Constants.appFont,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      _createAccountLabel(),
                                      Text(error)
                                    ],
                                  )),

                              //     //Button for anonyoums

                              // child: ElevatedButton(
                              //   onPressed: () async {
                              //     dynamic result = await _auth.signINAnon();
                              //     if (result == null) {
                              //       print('Sorry you are not logged in');
                              //     } else {
                              //       print('You are looged in ');
                              //       print(result);
                              //     }
                              //   },
                              //   child: Text('Anonymuos Sign In'),
                              // )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
