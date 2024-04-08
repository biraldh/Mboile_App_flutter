import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/Pages/Login.dart';


class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 110, 20, 110),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Forget Password?',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  TextFields(
                    label: 'EMAIL',
                    icon: const Icon(Icons.email_outlined),
                    controller: _emailController,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add your signup logic here
                          FirebaseAuth.instance.sendPasswordResetEmail(
                            email: _emailController.text,
                          ).then((value) {
                            // Show success message
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Reset Password Sent'),
                                  content: Text('A password reset link has been sent to your email.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Close the dialog
                                        Navigator.of(context).pop();
                                        // Navigate to the sign-in screen
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (context) => Login()),
                                        );
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }).catchError((error) {
                            // Handle errors, e.g., if the email is not registered
                            print('Error: $error');
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Reset",
                              style: TextStyle(
                                fontFamily: 'SFUIDisplay',
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.arrow_forward, size: 24.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Know Password?",
                style: TextStyle(
                  fontFamily: 'SFUIDisplay',
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontFamily: 'SFUIDisplay',
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFields extends StatelessWidget {
  final Icon icon;
  final String label;
  TextEditingController controller;
  bool secureText;

  TextFields({
    Key? key,
    required this.icon,
    required this.label,
    required this.controller,
    this.secureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        obscureText: secureText,
        style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          prefixIcon: icon,
          labelStyle: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}