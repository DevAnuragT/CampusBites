import 'package:campusbite/utilities/constants.dart';
import 'package:campusbite/utilities/login_container.dart';
import 'package:campusbite/utilities/signup_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoginSelected = true;

  String buttonText='Log In';
  final formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/logo2.jpg',
                      height: 250,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  color: kBackgroundColor,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isLoginSelected ? kColorTheme : Colors.transparent,
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoginSelected = true;
                                      buttonText='Log In';
                                    });
                                  },
                                  child: Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontFamily: 'SFRounded',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: !isLoginSelected ? kColorTheme : Colors.transparent,
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoginSelected = false;
                                      buttonText='Sign Up';
                                    });
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontFamily: 'SFRounded',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        // child:if(isLoginSelected==true){


                        child: !isLoginSelected ? SignupContainer():LoginContainer(),

                      )

                    ],
                  ),
                ),
              ),

              // Container(
              //   color: kBackgroundColor,
              //   padding: const EdgeInsets.all(16),
              //   child: SizedBox(
              //     width:kButtonSize,
              //     child: TextButton(
              //       onPressed: () {
              //         Navigator.pushNamed(context, LoginScreen.id);
              //       },
              //       style: kButtonStyle.copyWith(
              //         backgroundColor: MaterialStateProperty.all<Color>(kColorTheme),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(15),
              //         child: Text(
              //           buttonText,
              //           style: kButtonText.copyWith(color: Colors.white),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),


            ],
          ),
        ),
      ),
    );
  }
}
