import 'package:coffre_app/services/storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  FirebaseStorage storge = FirebaseStorage.instance;

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
    var Path;
    var FileName;

    return Scaffold(
      appBar: AppBar(title: Text('gfdgd')),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              TextButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['png', 'jpg']);
                  if (result == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No Image is There'),
                      ),
                    );
                    return null;
                  }
                  Path = result.files.single.path!;
                  FileName = result.files.single.name;

                  // storage
                  //     .uploudFile(path, fileName)
                  //     .then((value) => print('Uplouded'));

                  // String path = "Cust_orders_images/" + Uuid().v1() + ".png";
                  // Reference custimagesRef = storge.ref(path);
                  //  StorageMetadata a =
                },
                child: Text('pick Image'),
              ),
              TextButton(
                onPressed: () async {
                  storage
                      .uploudFile(Path, Uuid().v1())
                      .then((value) => print('Uplouded'));
                  // print(Path);
                  // print(FileName);
                  // print(path);
                  // print(fileName);

                  // String path = "Cust_orders_images/" + Uuid().v1() + ".png";
                  // Reference custimagesRef = storge.ref(path);
                  //  StorageMetadata a =
                },
                child: Text('Uploud Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
