import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestsList extends StatefulWidget {
  const RequestsList({Key? key}) : super(key: key);

  @override
  _RequestsListState createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  @override
  Widget build(BuildContext context) {
    final requests = Provider.of<List<Request>?>(context) ?? [];
    return ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return requets_tile(request: requests[index]);
        });
  }
}
