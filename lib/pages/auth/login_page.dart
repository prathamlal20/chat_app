// ignore_for_file: deprecated_member_use

import 'package:chat_app/pages/auth/signup_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  String email="";
  String password="";
  bool _isLoading=false;
  AuthService authService =AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading? Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),):SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Let's Rise",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(179, 36, 179, 1.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "With",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(179, 36, 179, 1.0),
                    ),
                  ),

                  const SizedBox(height: 10),
                  
                  const Text(
                    "Kandis",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(179, 36, 179, 1.0),
                    ),
                  ),
                  Image.asset("assets/login.png",height: 200,width: 500,),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      hintText: "Email",
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color(0xFFee7b64)
                      ), 
                      hintStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                    ),
                    onChanged: (val){
                        setState(() {
                          email = val;
                        });
                      }, 

                    validator: (val){
                      return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                        ).hasMatch(val!) ? null : "Please enter valid email";
                    },
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock,color: Color(0xFFee7b64)),
                      hintStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold )
                    ),
                    onChanged: (val){
                        setState(() {
                          password = val;
                        });
                      },
                    validator: (val){
                      if(val!.length<5 ){
                        return "Password must be atleast 6 characters";
                      }
                      else {
                        return null;
                      }
                    }, 
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFee7b64),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                        )
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white,fontSize: 16) ,
                      ),
                      onPressed: (){
                        login();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Don't have an account?",
                      style: const TextStyle(color: Colors.black,fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Sign Up",
                          style: const TextStyle(color: Colors.blue,fontSize: 14,decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap=() {
                            nextscreen(context, const SignUpPage());
                          },
                        ),
                      ],
                    ),

                  ),
                ], 
              ),
            ),
          ),
        ),
      );
  }

  login() async {
    if(formkey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithUserNameandPassword(email, password).then((value) async{
        if(value==true){
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .gettingUserData(email);
          // saving the values to our shared preferences
          
          nextscreenReplace(context, const HomePage());
        }
        else{
          showSnackBar(context, Colors.red, value );
          setState(() {
            _isLoading=false;
          });
        }
      });
    }
  }
}

