import 'package:firebase_auth/firebase_auth.dart';
import 'package:hchat/helper/helper_function.dart';
import 'package:hchat/service/database_service.dart';

class AuthService {
  late FirebaseAuth firebaseAuth;
  AuthService() {
    firebaseAuth = FirebaseAuth.instance;
  }
  AuthService.fromParam(FirebaseAuth firebaseAuth) {
    this.firebaseAuth = firebaseAuth;
  }

  /// Tries to login the user given an email and password.
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        // Call our Database service to update the user data
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Creates a user IF the user isn't null, and gives it a generated
  // Id. If there is an error, it throws an exception.
  Future registerUserWithEmailandPassword(String userName, String email,
      String password, String canvasAccessKey) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        // Call our Database service to update the user data
        await DatabaseService(uid: user.uid)
            .savingUserData(userName, email, canvasAccessKey);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// Function to singout a user. Turns the userLoggedInStatus
  /// to false, turns the userName, email, and canvasKey to a
  /// blank string, and uses FirebaseAuth to sing out of the account.
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserCanvasKeySF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
