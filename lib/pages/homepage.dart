
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/pages/post.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'groupcreate.dart';
import 'home.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  int pagenum = 0;
  List page = [
    home(),
    post(),
    groupcreate(),
  ];
  void onTabChange( int index){
    setState(() {
    pagenum = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[pagenum],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            rippleColor: Colors.black12,
            color: Colors.white,
            backgroundColor: Colors.black,
            activeColor: Colors.white,
            onTabChange: onTabChange,
            tabBackgroundColor: Colors.white10,
            gap: 8,
            tabs: const [
              GButton(icon: Icons.home,
              text: 'Home',),
              GButton(icon: Icons.add,
                text: 'Posts',),
              GButton(icon: Icons.group,
              text: 'Communities',),
            ],
          ),
        ),
      ),
    );
  }
}



