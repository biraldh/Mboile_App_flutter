import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterap/global/common/toast.dart';

class ProfileServices{
  Future<void>Updateprofile(email,name)async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(email)
        .update({'username' : name});
    showToast(message: "User name changed");
  }

  Future<void>Updateaddress(email,address)async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(email)
        .update({'Address' : address});
    showToast(message: "User address changed");
  }

  Future<void>Updatecontact(email,contact)async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(email)
        .update({'Contact' : contact});
    showToast(message: "User contact changed");
  }
}
