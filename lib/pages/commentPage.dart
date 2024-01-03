import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterap/services/commentService.dart';

class commentPage extends StatefulWidget {

  String postid;
  String? user;

  commentPage(
      {Key? key,
    required this.postid,
    required this.user,
    }): super(key: key);

  @override
  State<commentPage> createState() => _commentPageState();
}

class _commentPageState extends State<commentPage> {
  final commentService cService = commentService();
  final TextEditingController _commentcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                  stream: cService.getComments(widget.postid),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator(
                    color: Colors.white,
                    );
                    }else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}",style: const TextStyle(
                    color: Colors.white));
                    }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                    return const Text("No comments available.", style: TextStyle(
                    color: Colors.white
                    ),);
                    }else{
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index].data();
                          return ListTile(
                            title: Text(data['comment'], style: TextStyle(color: Colors.white)),
                            subtitle: Text(data['commentOwner'], style: TextStyle(color: Colors.white)),
                          );
                        }
                      );
                    }
                  },
                )),
            Container(
              color: Colors.brown[800],
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: width/1.2,
                      child: TextField(
                        controller: _commentcontroller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add a comment',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      cService.createComment(widget.user,widget.postid, _commentcontroller.text);
                    },
                    child: Icon(Icons.send, color: Colors.white,)
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
