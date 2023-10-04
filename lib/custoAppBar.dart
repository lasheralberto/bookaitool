import 'package:bookaitool/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  var title;
    CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0, // Remove the app bar shadow
      backgroundColor:
          ColorConstants.colorAppBar, // Set the background color to blue
      title: Text(
        this.title,
        style: TextStyle(
          fontFamily: 'Roboto', // Use Google's Roboto font
          fontWeight: FontWeight.bold, // Apply a bold font weight
          fontSize: 24, // Increase the font size
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search, // Add a search icon (you can change this)
            color: Colors.white, // Set the icon color to white
          ),
          onPressed: () {
            // Handle the search action
          },
        ),
        IconButton(
          icon: Icon(
            Icons.settings, // Add a settings icon (you can change this)
            color: Colors.white, // Set the icon color to white
          ),
          onPressed: () {
            // Handle the settings action
          },
        ),
      ],
    );
  }
}
