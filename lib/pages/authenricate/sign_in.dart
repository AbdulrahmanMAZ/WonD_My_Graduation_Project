import 'dart:convert';
import 'package:coffre_app/shared/constant.dart';
import 'package:coffre_app/pages/authenricate/authenticate.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color.fromARGB(255, 209, 204, 187),
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Log In'),
              actions: <Widget>[
                TextButton.icon(
                    onPressed: () {
                      widget.toggleVeiw!();
                    },
                    icon: Icon(Icons.login_rounded),
                    label: Text("Register"))
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      // E-Mail text field
                      TextFormField(
                          decoration: textInputDecoration,
                          validator: (val) =>
                              val!.isEmpty ? 'enter a value' : null,
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
                        validator: (val) =>
                            val!.length < 8 ? 'enter a password' : null,
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

                      ElevatedButton(
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
                                error = 'User Does not exist!';
                                loading = false;
                              });
                            }
                          }
                        },
                        child: Text('Log In'),
                        style: ElevatedButton.styleFrom(primary: Colors.amber),
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
          );
  }
}
