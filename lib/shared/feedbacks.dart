import 'dart:math';

import 'package:coffre_app/modules/rating.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Worker/worker_feedback_tile.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:flutter/material.dart';

class FeedBack extends StatelessWidget {
  final AcceptedRequest? req;
  final Rate? rateList;

  const FeedBack({Key? key, this.req, this.rateList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as AcceptedRequest;
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: StreamBuilder<List<Rate>>(
              stream: DatabaseService(uid: args.worker_ID).ratee,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  double avregeRating = 1;
                  List<Rate>? userRate = snapshot.data;

                  return Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(150, 0, 150, 0),
                      //   child: Card(),
                      // ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: userRate!.length,
                          itemBuilder: (context, index) {
                            //                 if (userRate != null) {
                            //   for (var item in userRate) {
                            //     avregeRating += item.rate;
                            //   }
                            // }
                            final _random = new Random();
                            print(userRate!.length);

                            if (userRate != null) {
                              return worker_feedback_tile(
                                  rate: userRate[index].rate,
                                  name: userRate[index].name,
                                  feedback: userRate[index].feedback);
                            }
                            return Loading();
                          }),
                    ],
                  );
                } else {
                  return Loading();
                }
              }),
        ),
      ),
    );
  }
}
