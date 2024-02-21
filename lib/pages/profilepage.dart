
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/firebase_auths.dart';
import '../services/profileServices.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final currentuser = FirebaseAuth.instance.currentUser;
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _contactcontroller = TextEditingController();
  final ProfileServices pservice = ProfileServices();
  bool nametext = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _namecontroller.dispose();
    _addresscontroller.dispose();
    _contactcontroller.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(iconTheme: IconThemeData( color: Colors. white,),title: Text("Profile", style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.black87,),
      body: FutureBuilder(
        future: _auth.getUserDetail(currentuser),
        builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.white,
          );
        }else if (snapshot.hasError) {
        // If an error occurs
        return Text('Error: ${snapshot.error}');
        } else {
          var userData = snapshot.data!.data();
          var name = userData!['username'];
          var email = userData!['email'];
          var contact = userData['Contact'] ?? "Your Contact";
          var address = userData['Address'] ?? "Your Address";

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: width / 3,
                    child: Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  IconButton(onPressed: editnamebox,
                      icon: Icon(Icons.edit, color: Colors.white,))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: width / 2,
                    child: Text(
                      address.isEmpty ? "provide your address" : address,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  IconButton(onPressed: editaddressbox,
                      icon: Icon(Icons.edit, color: Colors.white,))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: width / 2,
                    child: Text(
                      contact.isEmpty ? "provide your contact" : contact,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  IconButton(onPressed: editcontactbox,
                      icon: Icon(Icons.edit, color: Colors.white,))
                ],
              ),
              Text(email,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                ),
              ),
            ],
          );
          }
        }
      ),
    );
  }

  Future editnamebox() => showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        title: Text("Your name"),
        content: TextField(
          controller: _namecontroller,
          decoration: InputDecoration(
            hintText: "enter your name"
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){profilemod(_namecontroller.text, 'name');}, child: Text("Save"))
        ],
      )
  );

  Future editaddressbox() => showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        title: Text("Your Address"),
        content: TextField(
          controller: _addresscontroller,
          decoration: InputDecoration(
              hintText: "enter your Address"
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){profilemod(_addresscontroller.text, 'address');}, child: Text("Save"))
        ],
      )
  );

  Future editcontactbox() => showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        title: Text("Your Contact"),
        content: TextField(
          controller: _contactcontroller,
          decoration: InputDecoration(
              hintText: "enter your Contact"
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){profilemod(_contactcontroller.text, 'contact');}, child: Text("Save"))
        ],
      )
  );
  void profilemod(String value, String profilestatus){
    switch(profilestatus){
      case 'name':
        pservice.Updateprofile(currentuser?.email, value);
        break;
      case 'contact':
        pservice.Updatecontact(currentuser?.email, value);
        break;
      case 'address' :
        pservice.Updateaddress(currentuser?.email, value);
        break;
    }

  }
}

