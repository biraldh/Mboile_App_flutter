import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterap/pages/post.dart';
import 'package:uuid/uuid.dart';


class commentService{
  Future<void> createComment(user,postid,comment)async {
    var uuid = Uuid();
    String unname = '${comment}-${DateTime.timestamp().microsecond}';
    var commentId = uuid.v5(Uuid.NAMESPACE_URL, unname);
    FirebaseFirestore.instance
        .collection("Comment")
        .doc(commentId)
        .set({
          'commentId': commentId,
          'commentOwner':user,
          'comment':comment,
          'postid': postid,
          'commentedOn': DateTime.timestamp()
    });
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getComments(postid){
    return FirebaseFirestore.instance
        .collection("Comment")
        .where('postid', isEqualTo: postid)
        .orderBy('commentedOn', descending: true)
        .snapshots();
  }
}