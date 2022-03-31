import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Worker/veiwCustomerRequest.dart';
import 'package:coffre_app/pages/home/profile.dart';
import 'package:flutter/material.dart';

class worker_requets_tile extends StatelessWidget {
  final Request request;
  const worker_requets_tile({Key? key, required this.request})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.brown,
            radius: 25,
          ),
          title: Text(request.name),
          subtitle: Text("Need a Service"),
          onTap: () {
            Navigator.pushNamed(context, '/veiwCustomerRequest',
                arguments: {'Cust_ID': request.Cust_ID});
          },
        ),
      ),
    );
  }
}
