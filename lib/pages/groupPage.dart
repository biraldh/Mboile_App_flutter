import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/services/groupServices.dart';
import 'package:flutterap/services/postService.dart';

import 'commentPage.dart';

class groupPage extends StatefulWidget {
  String groupName;
  groupPage({Key? key,
    required this.groupName}): super(key: key);

  @override
  State<groupPage> createState() => _groupPageState();
}

class _groupPageState extends State<groupPage> {
  final postServices pService = postServices();
  //final FirebaseAuthServices authServices = FirebaseAuthServices();
  final currentuser = FirebaseAuth.instance.currentUser;
  final groupServices gService = groupServices();
  @override
  Widget build(BuildContext context) {
    String? user = currentuser?.email;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.black,
        child: Column(
          children: [
            Container(
              color: Colors.brown[800],
              height: height/3,
              width: width,
              child: StreamBuilder(
                stream: gService.singleGroup(widget.groupName),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  }else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}",style: const TextStyle(
                        color: Colors.white));
                  }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                    return const Center(
                      child: Text("No posts available.", style: TextStyle(
                          color: Colors.white, fontSize: 30
                      ),),
                    );
                  }else{
                    var data = snapshot.data!.docs[0].data();
                    return
                        Column(
                          children: [
                            SizedBox(
                              height: height/4.3,
                              width: width,
                              child: CachedNetworkImage(
                                imageUrl: data['urlImage'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(data['name'], style: TextStyle(fontSize: 30, color: Colors.white),),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      if(!(data['members'] as List).contains(user)) {
                                        joinGroup(user, data['name']);
                                      }else if((data['members'] as List).contains(user)){
                                        leaveGroup(user, data['name']);
                                      }
                                    },
                                    child: (data['members'] as List).contains(user)
                                        ?const Text("Joined", style: TextStyle(color: Colors.white),)
                                        :const Text("Join",style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(data['description'], style: TextStyle(color: Colors.white, fontSize: 20),),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('${data['mamberNo'].toString()} members', style: TextStyle(color: Colors.white, fontSize: 20),),
                                )
                              ],
                            )
                          ],
                        );
                  }
                }
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: pService.postByGroup(widget.groupName),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}",style: const TextStyle(
                          color: Colors.white));
                    }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                      return const Center(
                        child: Text("No posts available.", style: TextStyle(
                            color: Colors.white, fontSize: 30
                        ),),
                      );
                    }else{
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data();
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                          width: width/1.2,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                      width: width/1.9,
                                                      child: Text(data['Title'], maxLines: 2, style: const TextStyle(fontSize: 30,color: Colors.white),)),
                                                  InkWell(
                                                    onTap: () {
                                                      if(data['dislikedMembers'].contains(currentuser?.email)){
                                                        dislikeRemoveFunction(data['postId']);
                                                      }
                                                      if(data['likedMembers'].contains(currentuser?.email)){
                                                        likeRemoveFunction(data['postId']);
                                                      }else {
                                                        likeFunction(data['postId']);
                                                      }
                                                    },
                                                    child: data['likedMembers'].contains(currentuser?.email)
                                                        ?const Padding(
                                                      padding: EdgeInsets.all(8),
                                                      child: Icon(Icons.thumb_up_outlined,color: Colors.red),
                                                    )
                                                        :const Padding(
                                                      padding: EdgeInsets.all(8),
                                                      child: Icon(Icons.thumb_up_outlined,color: Colors.white),
                                                    ),
                                                  ),
                                                  Text(data['likeCount'].toString(), style: const TextStyle(fontSize: 25, color: Colors.white),),
                                                  InkWell(
                                                    onTap: () {
                                                      if(data['likedMembers'].contains(currentuser?.email)){
                                                        likeRemoveFunction(data['postId']);
                                                      }
                                                      if(data['dislikedMembers'].contains(currentuser?.email)){
                                                        dislikeRemoveFunction(data['postId']);
                                                      }else{
                                                        dislikeFunction(data['postId']);
                                                      }
                                                    },
                                                    child: data['dislikedMembers'].contains(currentuser?.email)
                                                        ?const Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Icon(Icons.thumb_down_outlined,color: Colors.red),
                                                    )
                                                        :const Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Icon(Icons.thumb_down_outlined,color: Colors.white),
                                                    ),
                                                  ),
                                                  Text(data['dislikeCount'].toString(), style: const TextStyle(fontSize: 25, color: Colors.white),),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width/1.3,
                                                    child: Text(data['Body'],
                                                        style: const TextStyle(fontSize: 20,color: Colors.white)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  child: data['Imageurl'] != null
                                                      ? SizedBox(
                                                        height: 250,
                                                        width: width/1,
                                                        child: CachedNetworkImage(
                                                          imageUrl: data['Imageurl'],
                                                          fit: BoxFit.cover,
                                                          width: 50,
                                                          height: 50,
                                                          placeholder: (context, url) =>
                                                          const CircularProgressIndicator(),
                                                    ),
                                                  )
                                                      :Container()
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text("published by ${data["postOwner"]}", style: const TextStyle(color: Colors.white),),
                                                  ),
                                                  InkWell(
                                                    onTap: (){
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => commentPage(
                                                            postid: data['postId'],
                                                            user: currentuser?.email
                                                        ),
                                                      ));
                                                    },
                                                    child: const Icon(Icons.comment, color: Colors.white,),
                                                  )
                                                ],
                                              )
                                            ],
                                          )

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }

                  }),
            ),
          ],
        ),
      )
    );
  }

  void likeFunction(postid){
    pService.addLikes(currentuser?.email, postid);
  }

  void dislikeFunction(postid){
    pService.addDislike(currentuser?.email, postid);
  }

  void dislikeRemoveFunction(postid){
    pService.removeDislike(currentuser?.email, postid);
  }

  void likeRemoveFunction(postid){
    pService.removeLikes(currentuser?.email, postid);
  }
  void joinGroup(user, gname)async{
    gService.groupJoin(user, gname);
  }
  void leaveGroup(user, gname)async{
    gService.groupleave(user, gname);
  }
}
