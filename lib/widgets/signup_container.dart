import 'package:campusbite/model/users.dart';
import 'package:campusbite/screens/authentication/mobile.dart';
import 'package:campusbite/screens/profile.dart';
import 'package:campusbite/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:campusbite/model/authorisation.dart';
import '../screens/authentication/forget_password.dart';
import '../screens/home.dart';
import '../utilities/constants.dart';

class SignupContainer extends StatefulWidget {
  String state;
  SignupContainer(this.state);

  @override
  State<SignupContainer> createState() => _SignupContainerState();
}

class _SignupContainerState extends State<SignupContainer> {
  bool _obscureText = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  String email = "";
  String password = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        SizedBox(
          width: 240,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email Required';
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )),
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password Required';
                    }
                    if (value.length < 8) {
                      return 'Password needs to be least 8 characters';
                    }
                  },
                ),
                if (widget.state == 'Log In')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ForgotPasswordScreen.id);
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.red.withOpacity(0.85)),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      email = _emailController.text.trim();
                      password = _passController.text.trim();
                      // login/signup
                      Authorisation auth = Authorisation();
                      User? user = await auth.signInWithEmailAndPassword(
                          email, password);
                      if (user != null) {
                        UserDetails _details = UserDetails(user: user);
                        bool phone = await _details.getNumber();
                        if (phone == true) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('LogIn Success'),
                            backgroundColor: kColorTheme,
                          ));
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              HomeScreen.id,
                                  (route) => false); //to be updated
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              PhoneNumberPage.id,
                                  (route) => false); //to be updated
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'User does not exist. Registering Instead.',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: kColorTheme,
                        ));
                        User? newuser = await auth.createUser(email, password);
                        if (newuser != null) {
                          UserDetails _details = UserDetails(user: newuser);
                          _details.registerUser();
                          bool phone = await _details.getNumber();
                          if (phone == true) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Registration Success'),
                              backgroundColor: kColorTheme,
                            ));
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                HomeScreen.id,
                                    (route) => false); //to be updated
                          } else {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                PhoneNumberPage.id,
                                    (route) => false); //to be updated
                          }
                        }

                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            PhoneNumberPage.id,
                                (route) => false); //to be updated
                      }
                      setState(() {
                        _isLoading = false;
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
                  child: _isLoading
                      ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : Text(
                    '${widget.state}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: _isLoading  ? null : () async {
            setState(() {
              _isLoading = true;
            });
            Authorisation auth = Authorisation();
            User? user = await auth.googleSignIn();
            if (user != null) {
              UserDetails details = UserDetails(user: user);
              details.registerUser();
              bool success = await details.getNumber();
              if (success == false)
                Navigator.pushNamedAndRemoveUntil(
                    context, PhoneNumberPage.id, (route) => false);
              else
                Navigator.pushNamedAndRemoveUntil(
                    context, ProfilePage.id, (route) => false);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Something went wrong",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: kColorTheme,
              ));
            }
            setState(() {
              _isLoading = false;
            });
          },
          child: SizedBox(
            width: 270,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/google_icon.png')),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${widget.state} with Google',
                      style: TextStyle(fontFamily: 'SFRounded'),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
