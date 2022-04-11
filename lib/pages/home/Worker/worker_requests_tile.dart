import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/profile.dart';
import 'package:flutter/material.dart';

class worker_requets_tile extends StatelessWidget {
  final Request request;
  const worker_requets_tile({Key? key, required this.request})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text(request.name),
              subtitle: Text(request.Description),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Accept Request'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Show details'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/Show_Request',
                        arguments: request);
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
