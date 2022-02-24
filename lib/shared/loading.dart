import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 39, 22, 5),
      child: SpinKitFadingCircle(
        color: Colors.red,
        size: 50,
      ),
    );
  }
}
