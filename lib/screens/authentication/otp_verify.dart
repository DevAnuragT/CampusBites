import 'dart:async';
import 'package:campusbite/screens/profile/profile.dart';
import 'package:campusbite/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utilities/constants.dart';
import '../home.dart';

class OTPVerificationPage extends StatefulWidget {
  String verificationId;
  final String phoneNumber;
  final String address;

  OTPVerificationPage(
      {required this.verificationId, required this.phoneNumber,required this.address});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isResendButtonEnabled = false;
  late Timer _timer;
  int _start = 30;
  bool _isLoading=false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendButtonEnabled = true;
        });
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification',style: kAppBarStyle),
        centerTitle: true,
        backgroundColor: kColorTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter OTP'),
            ),
            SizedBox(height: 20),
            _isLoading? CircularProgressIndicator(color: kColorTheme,):
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(100, 50), // Set width and height
                backgroundColor: kColorTheme, // Change button color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Set border radius
                ),
              ),
              onPressed: _isLoading? null : () {
                setState(() {
                  _isLoading=true;
                });
                _verifyOTP(context);
                setState(() {
                  _isLoading=false;
                });
              },
              child: Text(
                'Verify OTP',
                style: kButtonText.copyWith(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            _isResendButtonEnabled
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 50), // Set width and height
                      backgroundColor: Colors.white, // Change button color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Set border radius
                      ),
                    ),
                    onPressed:_isLoading ? null : () {
                      setState(() {
                        _isLoading=true;
                      });
                      _resendOTP();
                      setState(() {
                        _isLoading=false;
                      });
                    },
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(color: kColorTheme),
                    ),
                  )
                : Text('Resend OTP in $_start seconds'),
          ],
        ),
      ),
    );
  }

  void _verifyOTP(BuildContext context) async {
    final otp = _otpController.text.trim();
    final credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    try {
      await _auth.currentUser?.linkWithCredential(credential);
      await _storePhoneNumberToFirestore(widget.phoneNumber);
      _navigateToHome(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP. Please try again.'),backgroundColor: kColorTheme),
      );
    }
  }

  Future<void> _storePhoneNumberToFirestore(String phoneNumber) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'phone': phoneNumber,
        'address': widget.address,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  void _navigateToHome(BuildContext context) {
    // Navigate to home page or any other page
    Navigator.pushReplacementNamed(context, ProfilePage.id);
  }

  void _resendOTP() async {
    setState(() {
      _isResendButtonEnabled = false;
      _start = 30;
    });
    _startTimer();

    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification
        await _auth.currentUser?.linkWithCredential(credential);
        await _storePhoneNumberToFirestore(widget.phoneNumber);
        _navigateToHome(context);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed. Please try again.'),backgroundColor: kColorTheme),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          widget.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
