import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/services/groupServices.dart';
import 'package:image_picker/image_picker.dart';


import '../global/common/toast.dart';


class group extends StatefulWidget {
  const group({super.key});
  @override
  State<group> createState() => _groupState();
}

class _groupState extends State<group> {
  int quality = 80;
  bool isloading = false;
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  final groupServices _gservice = groupServices();
  final currentuser = FirebaseAuth.instance.currentUser;
  final TextEditingController _gNameController=  TextEditingController();
  final TextEditingController _gDescController=  TextEditingController();
  final TextEditingController _gurlController=  TextEditingController();
  @override
  void dispose() {
    _gNameController.dispose();
    _gDescController.dispose();
    _gurlController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
      ),
      body: Center(
        child: Container(
          height: height,
          width: width/2,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Group name",
                style: TextStyle(color: Colors.white, fontSize: 20),),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(style: TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                ),
                controller: _gNameController,),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Description",
                  style: TextStyle(color: Colors.white, fontSize: 20),),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(style: TextStyle(color: Colors.white, fontSize: 20),
                controller: _gDescController,),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Image",
                  style: TextStyle(color: Colors.white, fontSize: 20),),
              ),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => _pickImage_gallery(),
                    child: Icon(Icons.browse_gallery),
                  )
              ),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => _pickImage_camera(),
                    child: Icon(Icons.camera),
                  )
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    grCreate();
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 50,
                        width: 340,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.brown [800],
                        ),
                        child: const Center(
                          child: Text(
                            "Create",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      if (isloading)
                        const CircularProgressIndicator(
                          color: Colors.black,
                        ),
                    ],
                  ),
                ),
              ),
              if( imageFile != null)
                Container(
                  height: 300,
                  width: 300,
                  child: Image.file(File(imageFile!.path),
                    fit: BoxFit.cover,),
                )
            ],
          ),
        ),
      )
    );
  }


  Future _pickImage_gallery() async{
    final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality:quality);
    setState(() {
      imageFile = image;
    });
  }
  Future _pickImage_camera() async{
    final XFile? photo = await picker.pickImage(source: ImageSource.camera,imageQuality: quality);
    setState(() {
      imageFile = photo;
    });
  }

  void grCreate() async {
    setState(() {
      isloading = true;
    });
    final path = 'photos/${imageFile!.name}';
    final file = File(imageFile!.path);

    if (currentuser != null && currentuser is User) {
      String? user = currentuser?.email;
      if (user != null) {
        String name = _gNameController.text;
        String description = _gDescController.text;
        String url = _gurlController.text;

        _gservice.createGroupDoc(user, name, description, url,path, file);

      } else {
        showToast(message: 'Please try again later');
      }
    } else {
      showToast(message: 'Please try again later');
    }
    setState(() {
      isloading = false;
    });
  }

}
