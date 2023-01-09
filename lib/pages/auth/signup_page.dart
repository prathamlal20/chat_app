import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email="";
  String password="";
  String fullName="";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Register Here",
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
                    hintText: "Full Name",
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color(0xFFee7b64)
                    ), 
                    hintStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                  ),
                  onChanged: (val){
                      setState(() {
                        fullName = val;
                      });
                    }, 

                  validator: (val){
                    if(val!.isNotEmpty){
                      return null;
                    }  
                    else {
                      return "Name can't be empty";
                    }
                  },
                ),
              
                const SizedBox(height: 10),

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
                      "Create Account",
                      style: TextStyle(color: Colors.white,fontSize: 16) ,
                    ),
                    onPressed: (){
                      register();
                    },
                  ),
                ),
                
                const SizedBox(height: 10,),
                
                Text.rich(
                  TextSpan(
                    text: "Already have an account?",
                    style: const TextStyle(color: Colors.black,fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Login",
                        style: const TextStyle(color: Colors.blue,fontSize: 14,decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()..onTap=() {
                          nextscreen(context, const LoginPage());
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
  register() async{
    if(formkey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.registerUserWithEmailandPassword(fullName, email, password).then((value) async{
        if(value==true){
          //saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
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