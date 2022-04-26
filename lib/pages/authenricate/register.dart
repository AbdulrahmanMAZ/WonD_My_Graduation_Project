import 'package:coffre_app/pages/authenricate/authenticate.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';

class Register extends StatefulWidget {
//  const Register({Key? key}) : super(key: key);

  final Function toggleView;
  Register({required this.toggleView});
  final List<String> professions = [
    'Hairdresser',
    'Mechanic',
    'Electrician',
    'plumber'
  ];
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthSrrvice _auth = AuthSrrvice();
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  String? _currentProfession = 'Customer';
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
        : new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Color.fromARGB(255, 53, 8, 30),
              appBar: AppBar(
                backgroundColor: Color.fromARGB(221, 112, 55, 88),
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
                          const SizedBox(height: 15),
                          const Text(
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
                            "Nice to see you in our app,here is the register page and you can create new account from here",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: Constants.appFont,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
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
                              decoration: userInputDecoration,
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
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                color: AppColors.underlineColor,
                                width: 0.5,
                              )),

                              // Color when it is clicked
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 105, 21, 216),
                                  width: 0.5,
                                ),
                              ),
                              label: Text(
                                'Password',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: Constants.appFont,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                                size: 22,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 255, 17, 0),
                                  width: 0.6,
                                ),
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.underlineColor,
                                  width: 0.5,
                                ),
                              ),

                              // Color when not in clicked
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
                          Visibility(
                            visible: isWorker,
                            child: DropdownButtonFormField(
                              value: widget.professions[0],
                              //  icon: Icon(Icons.arrow_downward),
                              items: widget.professions.map((String e) {
                                return DropdownMenuItem(
                                    value: e, child: Text('$e '));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _currentProfession = newValue as String;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          // Register Button
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
                                  });
                                  dynamic result =
                                      await _auth.RegisterWithEmailAndPassword(
                                          username,
                                          email,
                                          password,
                                          isWorker,
                                          _currentProfession as String);
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
                              child: Text(
                                'Register',
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
