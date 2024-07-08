import 'package:campusbite/screens/profile/edit_profile.dart';
import 'package:campusbite/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  static const String id = "profile";
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  DocumentSnapshot? userData;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        userData = doc;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),
      appBar: AppBar(
        backgroundColor: Color(0xFFEDEDED),
        title: Text('My profile', style: kLargeText),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Personal details',
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, EditProfilePage.id);
                  },
                  child: Text(
                    'change',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            //SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0,horizontal: 16),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/profile_pic.jpg'),
                      ),
                      borderRadius: BorderRadius.circular(10.0), // Optional: to make the corners rounded
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData!['displayName'],
                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text(
                          userData!['email'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 2),
                        Divider(color: Colors.grey),
                        SizedBox(height: 2),
                        Text(
                          userData!['phone'],
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 2),
                        Divider(color: Colors.grey),
                        Text(
                          userData!['address'],
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3,horizontal: 10.0),
                      decoration: kProfileContainer,
                      child: ListTile(
                        title: Text('Orders'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Handle Orders tap
                        },
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3,horizontal: 10.0),
                      decoration: kProfileContainer,
                      child: ListTile(
                        title: Text('Pending reviews'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Handle Pending reviews tap
                        },
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3,horizontal: 10.0),
                      decoration: kProfileContainer,
                      child: ListTile(
                        title: Text('Faq'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Handle Faq tap
                        },
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3,horizontal: 10.0),
                      decoration: kProfileContainer,
                      child: ListTile(
                        title: Text('Help'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Handle Help tap
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 40),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, ProfilePage.id);
                    },
                    style: kButtonStyle.copyWith(
                      backgroundColor: MaterialStateProperty.all<Color>(kColorTheme),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('Update', style: kButtonText.copyWith(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
