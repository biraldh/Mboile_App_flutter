
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterap/global/common/toast.dart';


class postServices{

  String generateUniqueString(String user, String title, String postedOn) {
    return '$user - $title - $postedOn';
  }

  Future<void> createPost(user, title, body, group,imageFile) async{
    if(imageFile!= null) {
      final ref = FirebaseStorage.instance.ref().child('post_photos');
      DateTime postedOn = DateTime.now();
      String uniqueName = '${DateTime
          .now()
          .millisecondsSinceEpoch}_${imageFile.path
          .split('/')
          .last}';
      String uniqueid = generateUniqueString(user, title, postedOn.toString());
      await ref.child(uniqueName).putFile(imageFile);
      String imgUrl = await ref.child(uniqueName).getDownloadURL();
      if (title != null) {
        await FirebaseFirestore.instance
            .collection("Posts")
            .doc(uniqueid)
            .set({
          'postId': uniqueid,
          'Body': body,
          'Imageurl': imgUrl,
          'Title': title,
          'groupname': group,
          'likeCount': 0,
          'dislikeCount': 0,
          'likedMembers': '',
          'dislikedMembers': '',
          'postOwner': user,
          'postedOn': postedOn
        });
        showToast(message: "Post Created");
      }
    }else{
      DateTime postedOn = DateTime.now();
      String uniqueid = generateUniqueString(user, title, postedOn.toString());
      if (title != null) {
        await FirebaseFirestore.instance
            .collection("Posts")
            .doc(uniqueid)
            .set({
          'postId': uniqueid,
          'Body': body,
          'Imageurl': null,
          'Title': title,
          'groupname': group,
          'likeCount': 0,
          'dislikeCount': 0,
          'likedMembers': '',
          'dislikedMembers': '',
          'postOwner': user,
          'postedOn': postedOn
        });
        showToast(message: "Post Created");
      }
    }
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> listPost(order, user){
    String orderthin = '';
    bool oredertype = false;
    switch (order) {
      case 'One':
        orderthin = "postedOn";
        oredertype = true;
        break;
      case 'Two':
        orderthin = "likeCount";
        oredertype = true;
        break;
    }
    return FirebaseFirestore.instance
        .collection("Posts")
        .orderBy(orderthin, descending: oredertype)
        .snapshots();
  }

  Future<void> addLikes(user,postid)async {

    return FirebaseFirestore.instance
        .collection("Posts")
        .doc(postid)
        .update({
      'likeCount' : FieldValue.increment(1),
      'likedMembers': FieldValue.arrayUnion([user])
    }
    );
  }
  Future<void> removeLikes(user,postid)async {

    return FirebaseFirestore.instance
        .collection("Posts")
        .doc(postid)
        .update({
      'likeCount': FieldValue.increment(-1),
      'likedMembers': FieldValue.arrayRemove([user]),
    }
    );
  }

  Future<void> removeDislike(user,postid)async {

    return FirebaseFirestore.instance
        .collection("Posts")
        .doc(postid)
        .update({
      'dislikeCount': FieldValue.increment(-1),
      'dislikedMembers': FieldValue.arrayRemove([user]),
      }
    );
  }
  Future<void> addDislike(user,postid)async {

    return FirebaseFirestore.instance
        .collection("Posts")
        .doc(postid)
        .update({
      'dislikeCount' : FieldValue.increment(1),
      'dislikedMembers': FieldValue.arrayUnion([user])
    }
    );
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> ownersPost(user) {
    return FirebaseFirestore.instance
        .collection("Posts")
        .where("postOwner", isEqualTo: user)
        .snapshots();
  }
  Future<void> deletePost(postId) async {
    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .delete();
    
    showToast(message: "Post deleted");
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> postByGroup(gname) {
    return FirebaseFirestore.instance
        .collection("Posts")
        .where("groupname", isEqualTo: gname)
        .snapshots();
  }
}
