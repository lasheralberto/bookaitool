import 'package:bookaitool/Screens/LandingPage.dart';
import 'package:bookaitool/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  var title;
  bool hasTitle;

  CustomAppBar({
    super.key,
    required this.title,
    required this.hasTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<User?> getUser() async {
    var user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<dynamic> getRandomAvatar() async {
    var user = FirebaseAuth.instance.currentUser;

    String svgCode = RandomAvatarString(user!.email.toString());
    return svgCode;
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.notifications), // Example icon for demonstration
          onPressed: () {
            // Add notification functionality here
          },
        ),
        const SizedBox(width: 16), // Adjust the width as needed
        // Profile bubble in the app bar
        GestureDetector(
          onTap: () {
            showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(
                  100, 100, 0, 0), // Adjust position as needed
              items: [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Log Out'),
                    onTap: () async {
                      // Perform logout action here
                      // For example, you can add code to navigate to the login screen
                      _signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LandingPage()),
                          (route) => false);
                      //Navigator.of(context).pop();
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      // Navigate to settings or perform any settings action here
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
          child: FutureBuilder(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.photoURL != null) {
                return CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(snapshot.data!.photoURL
                      .toString()), // Replace with your image
                  backgroundColor: Colors.grey, // Placeholder background color
                );
              } else {
                return FutureBuilder(
                  future: getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return RandomAvatar(snapshot.data!.uid);
                    } else {
                      return RandomAvatar(DateTime.now().toIso8601String());
                    }
                  },
                );
              }
            },
          ),
        ),
        const SizedBox(width: 16), // Adjust the width as needed
      ],

      toolbarHeight: 400.0,
      elevation: 0, // Remove the app bar shadow
      backgroundColor:
          ColorConstants.colorAppBar, // Set the background color to blue
      title: hasTitle ? Text(title) : null, // Remove the title

      flexibleSpace: Center(
        child: Container(
          child: Image.asset(
            '/images/ink2.png',
            fit: BoxFit.cover, // Adjust the fit as needed
          ),
        ),
      ),
    );
  }
}
