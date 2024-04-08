import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker picker = ImagePicker();
  bool nametext = true;
  XFile? pickedimage;
  int quality = 80;

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
      appBar: AppBar(iconTheme: const IconThemeData( color: Colors. white,),title: Text("Profile", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black87,),
      body: FutureBuilder(
          future: _auth.getUserDetail_profile(currentuser),
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
                      Container(
                        height: height/3,
                        width: width/3,
                        child: userData['profilepictureurl']!= null?
                        SizedBox(
                          child: Image.network(
                            userData['profilepictureurl'],
                          ),
                        )
                            :Text(
                          "add an image",
                          style: const TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      IconButton(onPressed: _pickImage_for_profile,
                          icon: const Icon(Icons.folder, color: Colors.white,))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: width / 3,
                        child: Text(
                          name,
                          style: const TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      IconButton(onPressed: editnamebox,
                          icon: const Icon(Icons.edit, color: Colors.white,))
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
                          style: const TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      IconButton(onPressed: editaddressbox,
                          icon: const Icon(Icons.edit, color: Colors.white,))
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
                          icon: const Icon(Icons.edit, color: Colors.white,))
                    ],
                  ),
                  Text(email,
                    style: const TextStyle(
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
        title: const Text("Your name"),
        content: TextField(
          controller: _namecontroller,
          decoration: const InputDecoration(
              hintText: "enter your name"
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){profilemod(_namecontroller.text, 'name');}, child: const Text("Save"))
        ],
      )
  );

  Future editaddressbox() => showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        title: const Text("Your Address"),
        content: TextField(
          controller: _addresscontroller,
          decoration: const InputDecoration(
              hintText: "enter your Address"
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){profilemod(_addresscontroller.text, 'address');}, child: const Text("Save"))
        ],
      )
  );

  Future editcontactbox() => showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        title: const Text("Your Contact"),
        content: TextField(
          controller: _contactcontroller,
          decoration: const InputDecoration(
              hintText: "enter your Contact"
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){profilemod(_contactcontroller.text, 'contact');}, child: const Text("Save"))
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
  Future _pickImage_for_profile() async {
    final XFile? photo =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: quality);
    setState(() {
      if (photo != null){
        pickedimage = photo;
        updateProfilePick();
      }
      else{
        pickedimage = null;
      }
    });
  }

  void updateProfilePick() async{
    if(pickedimage != null){
      final profpic = File(pickedimage!.path);
      pservice.Updateprofilepic(currentuser?.email, profpic);
    }
  }
}