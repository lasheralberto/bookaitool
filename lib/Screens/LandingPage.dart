import 'package:bookaitool/constants.dart';
import 'package:bookaitool/loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool? _success;

  String? _userEmail;

  _loginUser(email, pass) async {
    try {
      final User? user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      ))
              .user;

      FirebaseFirestore.instance.collection('users').doc().set({
        'name': user!.displayName,
        'uid': user.uid,
        'email': user.email,
        'isEmailVerified': user.emailVerified, // will also be false
        'photoUrl': user.photoURL, // will always be null
      });

      setState(() {
        _success = true;
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      });
    } catch (e) {
      setState(() {
        _success = false;
      });
      print(e.toString());
    }
  }

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
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(38.0),
                    child: Card(
                      elevation: 50.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: StyleConstants
                            .border, // Adjust the radius as needed
                      ),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(38.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                controller: _emailController,
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                obscureText: true,
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                    labelText: 'Password'),
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                alignment: Alignment.center,
                                child: EasyButton(
                                  useWidthAnimation: true,
                                  borderRadius: 20.0,
                                  width: 100,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _loginUser(_emailController.text,
                                          _passwordController.text);
                                    }
                                  },
                                  idleStateWidget: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  loadingStateWidget:
                                      const CircularProgressIndicator(
                                    strokeWidth: 3.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(_success == null
                                    ? ''
                                    : (_success == true
                                        ? 'Successfully registered $_userEmail'
                                        : 'Registration failed')),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Your app's logo or title can go here
                // Example: Image.asset('assets/app_logo.png'),

                // Button to access the app
                ElevatedButton(
                    onPressed: () {
                      // Navigate to your app's main screen or home page
                      //Navigator.pushReplacementNamed(context, AppRoutes.signUp);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SignUpPopUp(); // Show the SignUpPopUp dialog
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor:
                          Colors.transparent, // Transparent background
                      padding: const EdgeInsets.all(16.0), // Adjust button size
                    ),
                    child: const Text('Sign Up')),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
