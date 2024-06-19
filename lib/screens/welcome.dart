import 'package:flutter/material.dart';
import 'package:campusbite/utilities/constants.dart';

class WelcomeScreen extends StatelessWidget {
  static const id = 'welcome_screen';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kColorTheme,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Hero( //use in login screen for logo
                      tag: 'logo',
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage('assets/logo2.jpg'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Food for\nHostelites!',
                    textAlign: TextAlign.left,
                    style: kTitleStyle,
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Flexible(
                child: Container(
                  height: 270,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 85,
                        bottom: 110,
                        child: Image.asset(
                          'assets/icons/pizza.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                      Positioned(
                        left: 170,
                        bottom: 30,
                        child: Image.asset(
                          'assets/icons/hamburger.png',
                          width: 160,
                          height: 160,
                        ),
                      ),
                      Positioned(
                        left: 40,
                        bottom: 0,
                        child: Image.asset(
                          'assets/icons/biryani.png',
                          width: 170,
                          height: 170,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {

                      },

                      style: kButtonStyle,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('Get Started', style: kButtonText),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}