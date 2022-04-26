import 'dart:convert';
import 'package:coffre_app/shared/constant.dart';
import 'package:coffre_app/pages/authenricate/authenticate.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coffre_app/shared/constant.dart';

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

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Color.fromARGB(255, 53, 8, 30),
              appBar: AppBar(
                backgroundColor: Color.fromARGB(221, 112, 55, 88),
                title: Text('Log In'),
                actions: <Widget>[
                  TextButton.icon(
                      onPressed: () {
                        widget.toggleVeiw!();
                      },
                      icon: Icon(Icons.people),
                      label: Text("Register"))
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: Constants.appFont,
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Nice to see you again,if you have an account you can login from here",
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
                              decoration: textInputDecoration,
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter an E-Mail' : null,
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
                            decoration: passwordInputDecoration.copyWith(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible!;
                                  });
                                },
                                icon: Icon(_passwordVisible!
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                            validator: (val) => val!.length < 8
                                ? 'Your password  must be longer than 8 letters'
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
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.backgroundColor,
                                elevation: 3,
                                fixedSize: Size(
                                  ScreenSettings.setScreenWidth(context, 0.85),
                                  ScreenSettings.setScreenHeight(
                                      context, 0.078),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                    error = '';
                                  });
                                  dynamic result =
                                      await _auth.SignInWithEmailAndPassword(
                                          email, password);

                                  if (result == null) {
                                    setState(() {
                                      error = 'Incorrect information';
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
                                'Log In',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: Constants.appFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
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
              ),
            ),
          );
  }
}
