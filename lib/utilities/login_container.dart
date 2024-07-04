import 'package:flutter/material.dart';

import 'constants.dart';


class LoginContainer extends StatefulWidget {
  const LoginContainer({super.key});

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  final formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Column(children: [


      SizedBox(height: 40,),
      SizedBox(
        width:240,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Email Required';
                  }

                },

              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(hintText: 'Password'),
                obscureText: true,
                validator: (value){
                  if(value!.isEmpty){
                    return 'Email Required';
                  }
                  if(value.length<8){
                    return 'Password needs to be least 8 characters';
                  }
                },

              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  if(formKey.currentState!.validate()){
                    print('valid form');
                  }
                  // Your button action code here
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(100, 50), // Set width and height
                  backgroundColor: kColorTheme, // Change button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Set border radius
                  ),
                ),
                child: Text('Log In',style: TextStyle(color: Colors.white),),
              ),



            ],
          ),

        ),
      ),
      SizedBox(
        height: 20,
      ),
      // SizedBox(
      //   height: 1,
      //   width: 300,
      //   child: Container(
      //     color: Colors.grey,
      //   ),
      // ),


      GestureDetector(
        onTap: (){

        },
        child: SizedBox(

          width: 270,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(


              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        child: Image.asset('assets/google_icon.png')
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text('Log In with Google',style: TextStyle(fontFamily: 'SFRounded'),)
                ],
              ),
            ),
          ),
        ),
      )
    ],);
  }
}
