import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          Image.network(
            'https://media.giphy.com/media/u00DkhlFRgkei3d3jG/giphy.gif',
              
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Your app's logo or title can go here
                // Example: Image.asset('assets/app_logo.png'),

                // Button to access the app
                ElevatedButton(
                  onPressed: () {
                    // Navigate to your app's main screen or home page
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), backgroundColor: Colors.transparent, // Transparent background
                    padding: const EdgeInsets.all(16.0), // Adjust button size
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 40.0, // Adjust icon size
                    color: Colors.white, // Icon color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
