import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     image: DecorationImage(
      //   image: AssetImage('images/1.jpg'),
      //   fit: BoxFit.cover,
      // )),
      color: Color.fromARGB(31, 82, 58, 58),
      child: Center(
        child: SpinKitCubeGrid(
          color: Color.fromARGB(255, 76, 70, 151),
          size: 50,
        ),
      ),
    );
  }
}
