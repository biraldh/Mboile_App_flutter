import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../forget_password.dart';
import '../services/firebase_auths.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isSigning = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  final FirebaseAuthServices _auth = FirebaseAuthServices();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(//topball
            top: -150,
            left: -80,
            child: Container(
              width: 600,
              height: 600,
              decoration: const BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 10,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent[100],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 700,
            left: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 700,
            left: 100,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent[100],
                shape: BoxShape.circle,
              ),
            ),
          ),
          //Emailbox
          Positioned(
            top: height / 2.7,
            left: 100,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    width: width / 2,
                    child: TextField(
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                        hintStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                //password box
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    width: width / 2,
                    child: TextField(
                      controller: _passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Password',
                        hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgetPassword(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                //sign in button
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _signIn,
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.brown[800],
                          ),
                          child: Center(
                            child: _isSigning
                                ? CircularProgressIndicator(color: Colors.brown)
                                : Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //signup button
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(" Have you Registered?"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });
    String email = _emailcontroller.text;
    String password = _passwordcontroller.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      Navigator.pushNamed(context, "/home");
    }
  }
}
