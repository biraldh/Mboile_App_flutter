import 'package:flutter/material.dart';
import 'package:flutterap/pages/Register.dart';
import 'package:flutterap/pages/commentPage.dart';
import 'package:flutterap/pages/createGroup.dart';
import 'package:flutterap/pages/home.dart';
import 'package:flutterap/pages/homepage.dart';
import 'package:flutterap/pages/userOwnedCommunity.dart';
import 'package:flutterap/pages/userOwnedPost.dart';

import 'Pages/Login.dart';



class RouteGen{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/register':
        return MaterialPageRoute(builder: (_) => registerPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => homepage());
      case '/group':
        return MaterialPageRoute(builder: (_) => group());
      case '/usersPost':
        return MaterialPageRoute(builder: (_) => usersPost());
      case '/usersCommunity':
        return MaterialPageRoute(builder: (_) => userCommunity());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}