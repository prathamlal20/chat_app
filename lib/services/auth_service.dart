import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future loginWithUserNameandPassword(String email,String password) async{
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password))
        .user!;
      if(user!=null){
        return true;
      }
    } on FirebaseAuthException catch (e){
      return e.message;
    }
  }

  Future registerUserWithEmailandPassword(String fullName,String email,String password) async{
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password))
        .user!;
      if(user!=null){
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e){
      return e.message;
    }
  }

  Future signOut() async{
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserEmailSF("");
      await firebaseAuth.signOut();
    }
    catch(e){
      return null;
    }
  }

}