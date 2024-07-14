import 'package:campusbite/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  static const String id = "edit_profile";
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User? user;
  DocumentSnapshot? userData;
  String? verificationId;
  bool _isLoading = false;
  List<String> addressOptions = ['IVH','GH', 'BH-1', 'BH-2','BH-3']; // Add your address options here

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

  void _editField(String field, String currentValue) {
    if (field == 'address') {
      _showAddressDropdown(field, currentValue);
    } else {
      TextEditingController _controller = TextEditingController(text: currentValue);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            keyboardType: field == 'phone'
                ? TextInputType.number
                : field == 'email'
                ? TextInputType.emailAddress
                : TextInputType.name,
            controller: _controller,
            decoration: InputDecoration(
              labelText: field,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.black87)),
            ),
            TextButton(
              onPressed: () {
                if (field == 'phone') {
                  _verifyPhoneNumber(_controller.text);
                } else {
                  _updateUserField(field, _controller.text);
                }
                Navigator.pop(context);
              },
              child: Text('Save', style: TextStyle(color: kColorTheme)),
            ),
          ],
        ),
      );
    }
  }

  void _showAddressDropdown(String field, String currentValue) {
    String selectedAddress = currentValue;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DropdownButton<String>(
              value: selectedAddress,
              onChanged: (String? newValue) {
                setState(() {
                  selectedAddress = newValue!;
                });
              },
              items: addressOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () {
              _updateUserField(field, selectedAddress);
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: kColorTheme)),
          ),
        ],
      ),
    );
  }

  void _verifyPhoneNumber(String phoneNumber) {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _updateUserPhoneNumber(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed. Please try again.'),backgroundColor: kColorTheme,),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
        });
        _promptForVerificationCode(phoneNumber);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
    );
  }

  void _promptForVerificationCode(String phoneNumber) {
    TextEditingController _codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Verification Code'),
        content: TextField(
          keyboardType: TextInputType.number,
          controller: _codeController,
          decoration: InputDecoration(
            labelText: 'Verification Code',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId!,
                smsCode: _codeController.text,
              );
              await _updateUserPhoneNumber(credential);
              Navigator.pop(context);
              setState(() {
                _isLoading = false;
              });
            },
            child: _isLoading
                ? CircularProgressIndicator(color: kColorTheme)
                : Text('Verify', style: TextStyle(color: kColorTheme)),
          ),
        ],
      ),
    );
  }

  Future<void> _updateUserPhoneNumber(PhoneAuthCredential credential) async {
    try {
      await user!.updatePhoneNumber(credential);
      print(user!.phoneNumber);
      await _updateUserField('phone', user!.phoneNumber!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number updated successfully.'),backgroundColor: kColorTheme),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number update failed. Please try again.'),backgroundColor: kColorTheme),
      );
    }
  }

  Future<void> _updateUserField(String field, String newValue) async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({field: newValue});
      _fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),
      appBar: AppBar(
        backgroundColor: Color(0xFFEDEDED),
        title: Text('Edit Account', style: kLargeText),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _buildEditableField('Name', userData!['displayName']),
            _buildEditableField('phone', userData!['phone']),
            _buildEditableField('email', userData!['email']),
            _buildEditableField('address', userData!['address']),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String fieldName, String fieldValue) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName.toUpperCase(),
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  fieldValue,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              TextButton(
                onPressed: () => _editField(fieldName.toLowerCase(), fieldValue),
                child: Text(
                  'EDIT',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
