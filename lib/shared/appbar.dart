import 'package:auto_size_text/auto_size_text.dart';
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
      title: AutoSizeText(
        name,
        style: TextStyle(fontSize: 18),
        maxLines: 2,
      ),
      backgroundColor: Colors.transparent,
      elevation: 12.0,
      shadowColor: Color.fromARGB(45, 179, 8, 231),
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
