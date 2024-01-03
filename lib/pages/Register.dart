
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/global/common/toast.dart';
import 'package:flutterap/services/firebase_auths.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  bool _isSigning = false;
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();

  @override
  void dispose() {
    _usernamecontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(//topball
              top: -100,
              left: -80,
              child: Container(
                  width: 600,
                  height: 600,
                  decoration: const BoxDecoration(
                    color: Colors.lightBlueAccent,
                    shape: BoxShape.circle,
                  )
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
                  )
              ),
            ),
            Positioned(
              top: height/2.5,
              left: 100,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: width/2,
                      child: TextField(
                        controller: _emailcontroller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: width/2,
                      child: TextField(
                        controller: _passwordcontroller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: width/2,
                      child: TextField(
                        controller: _usernamecontroller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Username',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.brown[800],
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: _signUp,
                          child: _isSigning ? CircularProgressIndicator(color: Colors.brown,):Text(
                            "Sign Up", style: TextStyle(fontSize: 20,color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: 150,
                left: width/2.5,
                child: Text("Register", style: TextStyle(
                  fontSize: 30
                ),)),
          ],
        ),
      ),
    );
  }
  void _signUp()async{
    setState(() {
      _isSigning = true;
    });
    String username = _usernamecontroller.text;
    String email = _emailcontroller.text;
    String password = _passwordcontroller.text;
    String name = _usernamecontroller.text;
    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    _auth.createUserDoc(user,name);

    setState(() {
      _isSigning = false;
    });

    if(user!= null) {
      showToast(message: 'User created successfully');
      Navigator.pushNamed((context), "/home");
    }
  }
}
