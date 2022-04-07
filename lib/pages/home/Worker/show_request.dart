import 'package:coffre_app/services/storage.dart';
import 'package:flutter/material.dart';

class ShowRequest extends StatefulWidget {
  const ShowRequest({Key? key}) : super(key: key);

  @override
  State<ShowRequest> createState() => _ShowRequestState();
}

class _ShowRequestState extends State<ShowRequest>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return FutureBuilder(
      future: storage.downloadURL('bs-04-1255720.jpg'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Container(
            width: 300,
            height: 250,
            child: Image.network(snapshot.data!, fit: BoxFit.cover),
          );
        }
        return Container();
      },
    );
  }
}
