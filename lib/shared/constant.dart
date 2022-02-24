import 'package:flutter/material.dart';

const textInputDecoration = const InputDecoration(
  hintText: 'Enter You Email',
  fillColor: Colors.white,
  filled: true,
  // Color when it is clicked
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black26, width: 5)),

  // Color when not in clicked
  enabledBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(66, 134, 134, 134), width: 5.0),
  ),
);

const passwordInputDecoration = InputDecoration(
  hintText: 'Enter You Password',
  fillColor: Colors.white,
  filled: true,

  // Color when it is clicked
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black26, width: 5)),

  // Color when not in clicked
  enabledBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(66, 136, 136, 136), width: 5.0),
  ),
);
