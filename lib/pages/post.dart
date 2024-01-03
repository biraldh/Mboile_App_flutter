import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/global/common/toast.dart';
import 'package:flutterap/pages/selectGroup.dart';
import 'package:flutterap/services/groupServices.dart';
import 'package:flutterap/services/postService.dart';
import 'package:image_picker/image_picker.dart';

class post extends StatefulWidget {
  const post({Key? key}) : super(key: key);

  @override
  State<post> createState() => _postState();
}

class _postState extends State<post> {
  bool isloading = false;
  XFile? pickedFile;
  int quality = 80;
  final postServices pservice = postServices();
  final groupServices gservice = groupServices();
  final currentuser = FirebaseAuth.instance.currentUser;
  final ImagePicker picker = ImagePicker();
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _bodycontroller = TextEditingController();

  @override
  void dispose() {
    _titlecontroller.dispose();
    _bodycontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String? user = currentuser?.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        automaticallyImplyLeading: false,
        title: const Text(
          "Post",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                //Title
                controller: _titlecontroller,
                style: TextStyle(fontSize: 35, color: Colors.white),
                maxLines: 2,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: "Title",
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              //body
              padding: EdgeInsets.all(8.0),
              child: TextField(
                //Title
                maxLines: 8,
                controller: _bodycontroller,
                style: const TextStyle(
                  fontSize: 25, color: Colors.white
                ),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: "Body",
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              width: width/1.5,
              decoration: BoxDecoration(
                color: Colors.brown[800],
                borderRadius: BorderRadius.circular(30)
              ),
              child: InkWell(
                onTap: () {
                  if (_titlecontroller.text.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => createPostContinue(
                        title: _titlecontroller.text,
                        body: _bodycontroller.text,
                        user: user,
                      ),
                    ));

                  }else{
                    showToast(message: "Must fill title");
                  }

                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(fontSize: 20,color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}