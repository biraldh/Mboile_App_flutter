import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterap/global/common/toast.dart';

class ProfileServices {

  Future<void> Updateprofile(email, name) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(email)
        .update({'username': name});
    showToast(message: "User name changed");
  }

  Future<void> Updateaddress(email, address) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(email)
        .update({'Address': address});
    showToast(message: "User address changed");
  }

  Future<void> Updatecontact(email, contact) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(email)
        .update({'Contact': contact});
    showToast(message: "User contact changed");
  }

  Future<void> Updateprofilepic(email, file) async {
    if (file != null) {
      final ref = FirebaseStorage.instance.ref().child('profile_photo');
      String uniqueName = '${DateTime
          .now()
          .millisecondsSinceEpoch}_${file.path
          .split('/')
          .last}';
      await ref.child(uniqueName).putFile(file);
      String imgUrl = await ref.child(uniqueName).getDownloadURL();
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(email)
          .update({'profilepictureurl': imgUrl});
    }
  }
}