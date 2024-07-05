import 'package:campusbite/screens/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utilities/constants.dart';
import '../home.dart';
import 'otp_verify.dart';

class PhoneNumberPage extends StatefulWidget {
  static const String id = "PhoneNumberPage";
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  String _selectedAddress = "IVH";
  String _phoneNum="+91";
  bool _isLoading=false;
  final List<String> _addresses = ["IVH", "GH", "BH-1", "BH-2", "BH-3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Link With Phone',
          style: kAppBarStyle,
        ),
        backgroundColor: kColorTheme,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration:
                      InputDecoration(labelText: 'Phone number',prefix:Text('+91  ')),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your phone number";
                    } else if (value.length != 10) {
                      return "Enter a 10-digit Phone number";
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedAddress,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAddress = newValue!;
                  });
                },
                items: _addresses.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              _isLoading? CircularProgressIndicator(color: kColorTheme,):
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading=true;
                    });
                    _phoneNum=_phoneNum+_phoneController.text.trim();
                    print("Phone Number: " + _phoneNum);
                    formKey.currentState!.save();
                    _verifyPhoneNumber(context);
                    _phoneNum="+91";
                    setState(() {
                      _isLoading=false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(100, 50), // Set width and height
                  backgroundColor: kColorTheme, // Change button color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Set border radius
                  ),
                ),
                child: Text(
                  'Verify',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validatePhoneNumber(String phoneNumber) {
    final phoneRegExp = RegExp(r'^\+\d{1,3}\d{1,14}$');
    return phoneRegExp.hasMatch(phoneNumber);
  }

  void _verifyPhoneNumber(BuildContext context) async {
    final phoneNumber = _phoneNum;
    if (!_validatePhoneNumber(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number.'),backgroundColor: kColorTheme,),
      );
      return;
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification
        try {
          await _auth.currentUser?.linkWithCredential(credential);
          await _storePhoneNumberToFirestore(phoneNumber, _selectedAddress);
          Navigator.pushNamed(context, HomeScreen.id);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification completed, but linking failed.'),backgroundColor: kColorTheme,),
          );
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed with error code: ${e.code}');
        print('Error message: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed. Please try again.'),backgroundColor: kColorTheme,),
        );
      },
      codeSent: (String verificationId, int? resendToken) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationPage(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
              address: _selectedAddress,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> _storePhoneNumberToFirestore(
      String phoneNumber, String address) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'phone': phoneNumber,
        'address': address,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  void _navigateToHome(BuildContext context) {}
}
