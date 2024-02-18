
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/global/common/toast.dart';
import 'package:flutterap/services/groupServices.dart';
import 'package:flutterap/services/postService.dart';
import 'package:image_picker/image_picker.dart';

class createPostContinue extends StatefulWidget {
  String title, body;
  String? user;

  createPostContinue(
      {Key? key,
        required this.title,
        required this.body,
        required this.user})
      : super(key: key);

  @override
  State<createPostContinue> createState() => _createPostContinueState();
}

class _createPostContinueState extends State<createPostContinue> {
  final postServices pservice = postServices();

  final ImagePicker picker = ImagePicker();

  int quality = 80;
  String name = "";
  XFile? pickedFile;

  final groupServices gservice = groupServices();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Pick an image",style: TextStyle(color: Colors.white),),
                  InkWell(
                    onTap: () => _pickImage_gallery_post(),
                    child: Icon(Icons.browse_gallery, color: Colors.white,),
                  ),
                  InkWell(
                    onTap: () => _pickImage_camera_post(),
                    child: Icon(Icons.camera, color: Colors.white,),
                  ),
                ],
              ),
            ),
            if (pickedFile != null)
              Container(
                height: 100,
                width: 100,
                child: Image.file(
                  File(pickedFile!.path),
                  fit: BoxFit.cover,
                ),
              ),
            const Padding(
              padding: EdgeInsets.only(top: 150.0),
              child: Text("Choose a community", style: TextStyle(color: Colors.white),),
            ),
            Container(
              width: width/1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.brown[800],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: "Search for group here",
                  ),
                  onChanged: (val){
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 300,
                width: 300,
                child: FutureBuilder(
                    future: gservice.listallGroup(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white));
                      } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text("No group data available.", style: TextStyle(color: Colors.white),);
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data();
                            if(data['name'].toString().toLowerCase().contains(name.toLowerCase())){
                              return InkWell(
                                onTap: () => createPost(data['name']),
                                child: Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: ListTile(
                                    title: Text(
                                      data['name'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                        data['description'],
                                        style: TextStyle(color: Colors.white)
                                    ),
                                    leading: data['urlImage'] != null
                                        ? CachedNetworkImage(
                                          imageUrl: data['urlImage'],
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                          placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                    )
                                        : const Icon(Icons.image, size: 50),
                                  ),
                                ),
                              );
                            }else{
                              return Container();
                            }
                          },
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _pickImage_gallery_post() async {
    final XFile? image =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: quality);
    setState(() {
      if (image != null){
        pickedFile = image;
      }
      else{
        pickedFile = null;
      }
    });
  }

  Future _pickImage_camera_post() async {
    final XFile? photo =
    await picker.pickImage(source: ImageSource.camera, imageQuality: quality);
    setState(() {
      if (photo != null){
        pickedFile = photo;
      }
      else{
        pickedFile = null;
      }
    });
  }

  void createPost(name) async {
    if (widget.user != null && pickedFile != null) {
      final file = File(pickedFile!.path);
      pservice.createPost(widget.user, widget.title, widget.body, name, file);
    } else {
      pservice.createPost(widget.user, widget.title, widget.body, name, pickedFile);
    }

    Navigator.pushNamed((context), "/home");
  }
}