import 'package:coffre_app/modules/user.dart';
import 'package:coffre_app/pages/authenricate/authenticate.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';

class Register extends StatefulWidget {
//  const Register({Key? key}) : super(key: key);

  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthSrrvice _auth = AuthSrrvice();
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String username = '';
  String error = '';
  bool loading = false;
  bool isWorker = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color.fromARGB(255, 209, 204, 187),
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Sign Up'),
              actions: <Widget>[
                TextButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.login_rounded),
                    label: Text("Log In"))
              ],
            ),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        //Username text field
                        // TextFormField(
                        //     decoration: textInputDecoration.copyWith(),
                        //     validator: (val) =>
                        //         val!.isEmpty ? 'enter a value' : null,
                        //     onChanged: (val) {
                        //       setState(() {
                        //         username = val;
                        //       });
                        //     }),

                        // E-Mail text field
                        TextFormField(
                            decoration: textInputDecoration.copyWith(),
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
                        TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Enter your name'),
                            validator: (val) =>
                                val!.isEmpty ? 'enter a value' : null,
                            onChanged: (val) {
                              setState(() {
                                username = val;
                              });
                            }),
                        SizedBox(
                          height: 20,
                        ),

                        //Password text field
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter You Password',
                            fillColor: Colors.white,
                            filled: true,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(_passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),

                            // Color when it is clicked
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 5)),

                            // Color when not in clicked
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(66, 136, 136, 136),
                                  width: 5.0),
                            ),
                          ),
                          validator: (val) =>
                              val!.length < 8 ? 'enter a password' : null,
                          obscureText: _passwordVisible,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CheckboxListTile(
                          title: Text('Register as a worker'),
                          value: this.isWorker,
                          onChanged: (value) {
                            setState(() {
                              this.isWorker = value as bool;
                            });
                          },
                        ),

                        // Register Button
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _auth.RegisterWithEmailAndPassword(
                                      username, email, password, isWorker);
                              print(result);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = 'Invalid email';
                                });
                              }
                              // print(email);
                              // print(password);
                            }
                          },
                          child: Text('Register'),
                          style:
                              ElevatedButton.styleFrom(primary: Colors.amber),
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
          );
  }
}
