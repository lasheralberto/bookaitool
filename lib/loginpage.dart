import 'package:bookaitool/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_loading_button/easy_loading_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  var _password = '';
  var _confirmPassword = '';

  bool? _success;
  String? _userEmail;

  _registerUser(email, pass) async {
    if (_password != _confirmPassword) {
      _showCupertinoDialog(
          context, 'Passwords do not match.', 'Re-type password again.');
    }

    try {
      final User? user =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
    } on FirebaseAuthException catch (e) {
      setState(() {
        _success = false;
      });
      (context, e.code, e.message.toString());
    } catch (e) {
      _showCupertinoDialog(context, e, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(
                context, AppRoutes.landing); // Go back to the previous screen
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              onChanged: (val) {
                setState(() {
                  _password = val;
                });
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              obscureText: true,
              controller: _passwordConfirmController,
              decoration: const InputDecoration(labelText: 'Password'),
              onChanged: (val) {
                _confirmPassword = val;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: EasyButton(
                borderRadius: 20.0,
                width: 100,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _registerUser(
                        _emailController.text, _passwordController.text);
                  }
                },
                idleStateWidget: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                loadingStateWidget: const CircularProgressIndicator(
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
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(
                context, AppRoutes.landing); // Go back to the previous screen
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _loginUser(_emailController.text, _passwordController.text);
                  }
                },
                child: _success == true
                    ? InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: const Text('Go'))
                    : const Text('Submit'),
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
    );
  }
}

void _showCupertinoDialog(context, title, content) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close')),
          ],
        );
      });
}

class SignUpPopUp extends StatefulWidget {
  @override
  State<SignUpPopUp> createState() => _SignUpPopUpState();
}

class _SignUpPopUpState extends State<SignUpPopUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  var _password = '';
  var _confirmPassword = '';

  bool? _success;
  String? _userEmail;

  _registerUser(email, pass) async {
    if (_password != _confirmPassword) {
      _showCupertinoDialog(
          context, 'Passwords do not match.', 'Re-type password again.');
    }

    try {
      final User? user =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
    } on FirebaseAuthException catch (e) {
      setState(() {
        _success = false;
      });
      _showCupertinoDialog(context, e.code, e.message.toString());
    } catch (e) {
      _showCupertinoDialog(context, e, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sign Up',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  onChanged: (val) {
                    setState(() {
                      _password = val;
                    });
                  },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordConfirmController,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  onChanged: (val) {
                    _confirmPassword = val;
                  },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _registerUser(
                          _emailController.text, _passwordController.text);
                    }
                  },
                  child: Text('Sign Up'),
                ),
                SizedBox(height: 8),
                Text(_success == null
                    ? ''
                    : (_success == true
                        ? 'Successfully registered $_userEmail'
                        : 'Registration failed')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCupertinoDialog(context, title, content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
