import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutterap/global/common/toast.dart';


class groupServices {
  Future<void> createGroupDoc(user, name, description, url, path, file) async {
    // Check if the group name already exists
    bool nameExists = await doesNameAlreadyExist(name);

    if (nameExists) {
      showToast(message: "Group name already exists. Please choose a different name.");
    } else {
      String imgurl = "";
      final ref = FirebaseStorage.instance.ref().child('photos');

      String uniqueName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

      await ref.child(uniqueName).putFile(file);
      imgurl = await ref.child(uniqueName).getDownloadURL() as String;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection("Groupe")
            .doc(name)
            .set({
          'owner': user,
          'name': name,
          'urlImage': imgurl,
          'description': description,
          'mamberNo' : FieldValue.increment(1),
          'members': FieldValue.arrayUnion([user])
        });

        showToast(message: "Group Created");
      }
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> personalGroup(user) {
    return FirebaseFirestore.instance
        .collection("Groupe")
        .where('members',arrayContains: user)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> listallGroup() {
    return FirebaseFirestore.instance
        .collection("Groupe")
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listGroups(user) {
    return FirebaseFirestore.instance
        .collection("Groupe")
        .where('owner', isNotEqualTo: user)
        .snapshots();
  }


  Future<bool> doesNameAlreadyExist(String name) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('Groupe')
          .where('name', isEqualTo: name.toLowerCase())
          .limit(1)
          .get();

      final List<DocumentSnapshot> documents = result.docs;
      return documents.isNotEmpty; 
    } catch (error) {
      print("Error checking name existence: $error");

      return false;
    }
  }

  Future<void> groupJoin(user,group) async{
    if(user!= null && group!=null){
          await FirebaseFirestore.instance
          .collection("Groupe")
          .doc(group)
          .update({
            'mamberNo' : FieldValue.increment(1),
            'members': FieldValue.arrayUnion([user])
      });
      showToast(message: "Joined");
    }
  }

  Future<void> groupleave(user,group) async{
    if(user!= null && group!=null){
      await FirebaseFirestore.instance
          .collection("Groupe")
          .doc(group)
          .update({
        'mamberNo' : FieldValue.increment(-1),
        'members': FieldValue.arrayRemove([user])
      });
      showToast(message: "Left");
    }
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> singleGroup(gname){
    return FirebaseFirestore.instance
        .collection("Groupe")
        .where('name',isEqualTo: gname)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getsearchedgroup() async{
    return FirebaseFirestore.instance
        .collection("Groupe")
        .doc()
        .get();
  }
}