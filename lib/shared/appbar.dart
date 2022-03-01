import 'package:flutter/material.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final List<Widget> widget;

  const MyCustomAppBar({
    Key? key,
    required this.name,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(name),
      backgroundColor: Color.fromARGB(255, 38, 70, 173),
      elevation: 12.0,
      shadowColor: Colors.black,
      actions: widget,
      toolbarTextStyle: TextTheme(
        headline6: TextStyle(
          // headline6 is used for setting title's theme
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 24,
        ),
      ).bodyText2,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
