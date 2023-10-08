import 'package:bookaitool/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  var title;
  bool hasTitle;
  CustomAppBar({super.key, required this.title, required this.hasTitle});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0, // Remove the app bar shadow
      backgroundColor:
          ColorConstants.colorAppBar, // Set the background color to blue
      title: hasTitle
          ? Text(title)
          : Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                '/images/inkwiz.png',
                height: 30,
              ),
            ),
      //centerTitle: true,
      actions: const [],
    );
  }
}
