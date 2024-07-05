import 'package:campusbite/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authorisation{
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> googleSignIn() async{
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null){
        // UserDetails details=UserDetails(user: user);
        // details.registerUser();
        return user;
      }
      else return null;
    } catch (e) {
      print('Error during Google Sign-In: $e');
      return null;
    }
  }
  Future<User?> signInWithEmailAndPassword(String email, String password) async{
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user!= null){
        return user;
      }
      else return null;
    } catch (e) {
      print('Error during Sign-In: $e');
      return null;
    }
  }

  Future<User?> createUser(String email, String password) async{
     UserCredential userCredential= await _auth.createUserWithEmailAndPassword(email: email, password:password);
    final newUser=userCredential.user;
    if(newUser!=null) return newUser;
    else return null;
  }
}