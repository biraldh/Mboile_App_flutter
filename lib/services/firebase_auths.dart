import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../global/common/toast.dart';

class FirebaseAuthServices{
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch(e){
      showToast(message: '${e.code}');
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch(e){
      showToast(message: '${e.code}');
    }
    return null;
  }

  Future<void>createUserDoc(user, name)async {
    if(user != null){
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.email)
          .set({'email': user!.email,
              'username' : name,
          });
    }
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetail(currentuser) async{
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentuser!.email)
        .get();
  }
  Future<void> signOut()async{
    await _auth.signOut();
  }
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

}