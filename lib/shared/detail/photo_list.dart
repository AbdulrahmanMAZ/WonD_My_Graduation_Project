// import 'package:flutter/material.dart';

// // import '../../dummy.dart';

// class PhotoList extends StatelessWidget {
//   const PhotoList({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 30),
//       child: SizedBox(
//         height: 221,
//         width: double.infinity,
//         child: ListView.builder(
//           shrinkWrap: true,
//           scrollDirection: Axis.horizontal,
//           itemCount: photos.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 25),
//               child: SizedBox(
//                 height: 221,
//                 width: 310,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Image.asset(
//                     photos[index],
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
