import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/Extensions/chat_pages/chat_page.dart';
import 'package:flutterap/services/postService.dart';

import '../services/firebase_auths.dart';
import 'commentPage.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _HomeState();
}

class _HomeState extends State<home> {
  final FirebaseAuthServices authServices = FirebaseAuthServices();
  final currentuser = FirebaseAuth.instance.currentUser;
  final postServices pService = postServices();
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            children: [
              const DrawerHeader(
                child: Text(
                  "Menu",
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.post_add,
                  color: Colors.white,
                ),
                title: Text(
                  "My post",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/usersPost");
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.message_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  "Chats",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/chatDefault");
                },
              ),
              InkWell(
                onTap: () {
                  authServices.signOut();
                  Navigator.pushNamed(context, "/login");
                },
                child: Container(
                  height: 30,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.brown[800],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      "Sign out",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            DropdownButton<String>(
              value: dropdownValue,
              dropdownColor: Colors.greenAccent,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              iconSize: 25,
              style: const TextStyle(color: Colors.white, fontSize: 25),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: const [
                DropdownMenuItem<String>(
                  value: "One",
                  child: Text("Latest"),
                ),
                DropdownMenuItem<String>(
                  value: "Two",
                  child: Text("Most Liked"),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: pService.listPost(dropdownValue, currentuser?.email),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.white);
                  } else if (snapshot.hasError) {
                    return Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.white),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text(
                      "No posts available.",
                      style: TextStyle(color: Colors.white),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: width / 1.2,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: width / 1.9,
                                              child: Text(
                                                data['Title'],
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (data['dislikedMembers']
                                                    .contains(
                                                        currentuser?.email)) {
                                                  dislikeRemoveFunction(
                                                      data['postId']);
                                                }
                                                if (data['likedMembers']
                                                    .contains(
                                                        currentuser?.email)) {
                                                  likeRemoveFunction(
                                                      data['postId']);
                                                } else {
                                                  likeFunction(data['postId']);
                                                }
                                              },
                                              child: data['likedMembers']
                                                      .contains(
                                                          currentuser?.email)
                                                  ? const Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Icon(
                                                        Icons.thumb_up_outlined,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  : const Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Icon(
                                                        Icons.thumb_up_outlined,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                            ),
                                            Text(
                                              data['likeCount'].toString(),
                                              style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (data['likedMembers']
                                                    .contains(
                                                        currentuser?.email)) {
                                                  likeRemoveFunction(
                                                      data['postId']);
                                                }
                                                if (data['dislikedMembers']
                                                    .contains(
                                                        currentuser?.email)) {
                                                  dislikeRemoveFunction(
                                                      data['postId']);
                                                } else {
                                                  dislikeFunction(
                                                      data['postId']);
                                                }
                                              },
                                              child: data['dislikedMembers']
                                                      .contains(
                                                          currentuser?.email)
                                                  ? const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        Icons
                                                            .thumb_down_outlined,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  : const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        Icons
                                                            .thumb_down_outlined,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                            ),
                                            Text(
                                              data['dislikeCount'].toString(),
                                              style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: width / 1.3,
                                              child: Text(
                                                data['Body'],
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          child: data['Imageurl'] != null
                                              ? Container(
                                                  height: 250,
                                                  width: width / 1,
                                                  child: CachedNetworkImage(
                                                    imageUrl: data['Imageurl'],
                                                    fit: BoxFit.cover,
                                                    width: 50,
                                                    height: 50,
                                                    placeholder: (context,
                                                            url) =>
                                                        const CircularProgressIndicator(),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  String postOwnerEmail =
                                                      data["postOwner"];
                                                  String currentUserId =
                                                      (await FirebaseAuth
                                                                  .instance
                                                                  .currentUser)
                                                              ?.uid ??
                                                          '';

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPage(
                                                        recieverEmail:
                                                            postOwnerEmail,
                                                        receiverID:
                                                            currentUserId,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  "published by ${data["postOwner"]}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        commentPage(
                                                      postid: data['postId'],
                                                      user: currentuser?.email,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Icon(
                                                Icons.comment,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void likeFunction(postid) {
    pService.addLikes(currentuser?.email, postid);
  }

  void dislikeFunction(postid) {
    pService.addDislike(currentuser?.email, postid);
  }

  void dislikeRemoveFunction(postid) {
    pService.removeDislike(currentuser?.email, postid);
  }

  void likeRemoveFunction(postid) {
    pService.removeLikes(currentuser?.email, postid);
  }
}
