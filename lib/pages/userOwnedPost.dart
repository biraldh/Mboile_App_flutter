import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/postService.dart';

class usersPost extends StatefulWidget {
  const usersPost({super.key});

  @override
  State<usersPost> createState() => _usersPostState();
}

class _usersPostState extends State<usersPost> {
  final postServices _pService = postServices();
  final currentuser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.brown[800],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("My Posts", style: TextStyle(fontSize: 30, color: Colors.white),),
              )
            ),
            Expanded(
                child: StreamBuilder(
                  stream: _pService.ownersPost(currentuser?.email),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator(
                    color: Colors.white,
                    );
                    }else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}",style: const TextStyle(
                    color: Colors.white));
                    }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                    return const Text("No posts available.", style: TextStyle(
                    color: Colors.white
                    ),);
                    }else{
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index].data();
                          return  Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white12,
                              ),
                              width: 200,
                              margin: const EdgeInsets.only(top: 10),
                              child: ListTile(
                                title: Text(
                                  data['Title'],style: const TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                subtitle: Text(
                                  data['Body'],style: const TextStyle(color: Colors.white),
                                ),
                                leading: data['Imageurl'] != null
                                    ? CachedNetworkImage(
                                      imageUrl: data['Imageurl'],
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                )
                                    : const Icon(Icons.image, size: 50),
                                trailing: GestureDetector(
                                  onTap: () {_deletePost(data['postId']);},
                                    child: Icon(Icons.delete, color: Colors.white,)),
                              ),
                            ),
                          );
                        }
                      );
                    }
                  }
                ))
          ],
        ),
      ),
    );
  }
  void _deletePost(data) async{
    _pService.deletePost(data);
  }
}
