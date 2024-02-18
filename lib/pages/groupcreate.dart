
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/pages/groupPage.dart';
import 'package:flutterap/services/groupServices.dart';


class groupcreate extends StatefulWidget {
  const groupcreate({super.key});

  @override
  State<groupcreate> createState() => _groupcreateState();
}

class _groupcreateState extends State<groupcreate> {
  final currentuser = FirebaseAuth.instance.currentUser;
  final groupServices gService = groupServices();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String name = "";
  @override
  Widget build(BuildContext context) {

    String? user = currentuser?.email;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        automaticallyImplyLeading: false,
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (val){
            setState(() {
              name = val;

            });
          },
        )
      ),

      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
        },
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/group');
                    },
                    child: Container(
                      height: 50,
                      width: 340,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.brown[800],
                      ),
                      child: const Center(
                        child: Text(
                          "Create",
                          style: TextStyle(
                            fontSize: 20,color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text("Joined Community",style: TextStyle(color: Colors.white, fontSize: 25),),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          future: gService.personalGroup(user),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}",style: const TextStyle(color: Colors.white));
                            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Text("No group available.", style: TextStyle(color: Colors.white),);
                            } else {
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data!.docs[index].data();
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => groupPage(
                                              groupName: data['name']
                                          ),
                                        ));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.white12,
                                        ),
                                        width: 200,
                                        margin: const EdgeInsets.only(top: 10),
                                        child: ListTile(
                                          title: Text(
                                            data['name'],style: const TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                          subtitle: Text(
                                            data['description'],style: const TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
                                          ),
                                            leading: data['urlImage'] != null
                                                ? CachedNetworkImage(
                                                  imageUrl: data['urlImage'],
                                                  fit: BoxFit.cover,
                                                  width: 50,
                                                  height: 50,
                                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                            )
                                                : const Icon(Icons.image, size: 50),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                    ),
                    const Text("Communities",style: TextStyle(color: Colors.white, fontSize: 25)),
                    //preference list of group
                    Expanded(
                      child: StreamBuilder(
                        stream: gService.listGroups(user),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const CircularProgressIndicator();
                          }else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}",style: const TextStyle(color: Colors.white));
                          }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                            return const Text("No group data available.",style: TextStyle(color: Colors.white));
                          }else{
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data!.docs[index].data();
                                  if(data['name'].toString().toLowerCase().contains(name.toLowerCase())){

                                    return Container(
                                      width: 150,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Card(
                                        color: Colors.white10,
                                        child: SizedBox(
                                          height: 100,
                                          width: width/1,
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: (){
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => groupPage(
                                                        groupName: data['name']
                                                    ),
                                                  ));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    height: 100,
                                                    width: 150,
                                                    child: data['urlImage'] != null
                                                        ? CachedNetworkImage(
                                                        imageUrl: data['urlImage'],
                                                        fit: BoxFit.cover,
                                                        width: 50,
                                                        height: 50,
                                                        placeholder: (context, url) =>
                                                          const CircularProgressIndicator(),
                                                    )
                                                        : const Center(
                                                        child: CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(data['name'], style: const TextStyle(fontSize: 25, color: Colors.white),),
                                                    Text(data['description'], style: const TextStyle(fontSize: 20,color: Colors.white),overflow: TextOverflow.ellipsis,),
                                                    Text("Members : ${data['mamberNo']}", style: const TextStyle(fontSize: 15, color: Colors.white))
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: Center(
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
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }else {
                                    return Container();
                                  }
                                });
                          }
                        },
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void joinGroup(user, gname)async{
    gService.groupJoin(user, gname);
  }
  void leaveGroup(user, gname)async{
    gService.groupleave(user, gname);
  }
}
