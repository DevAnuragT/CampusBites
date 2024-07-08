import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetails {
  User user;
  UserDetails({required this.user});
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser() async {
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'address': "",
        'phone': "",
        'reviews': {}, // Map
        'orders': {}, // Map
      });
    }
  }

  Future<bool> getNumber() async{
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    String phone = userDoc['phone'];
    if(phone == ""){
      return false;
    }else{
      return true;
    }
  }
}

