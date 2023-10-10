import 'package:shared_preferences/shared_preferences.dart';

/// Helper functions to help other classes do their job easily.
/// All of these methods use SharedPreferences which saves
/// data in key value format.
class HelperFunctions {
  //Keys
  static String userLoggedInKey = "LOGGEDINKEY*";
  static String userNameKey = "USERNAMEKEY*";
  static String userEmailKey = "USEREMAILKEY*";
  static String userCanvasKey = "USERCANVASKEY*";

  /// Setters for Shared Preferences.

  /// Setter for the Boolean userLoggedInStatus of a
  /// users SharedPreferences.
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  /// Setter for the String userName of a users SharedPreferences.
  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  /// Setter for the String userEmail of a users SharedPreferences.
  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  /// Setter for the String userCanvasKey of a users SharedPreferences.
  static Future<bool> saveUserCanvasKeySF(String inputUserCanvasKey) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userCanvasKey, inputUserCanvasKey);
  }

  /// Getters for SharedPreferences.

  /// Getter for the Boolean userLoggedInStatus in SharedPreferences.
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  /// Getter for the String userEmail in SharedPreferences.
  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  /// Getter for the String userName from SharedPreferences.
  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  /// Getter for the String CanvasKey from SharedPreferences.
  static Future<String?> getCanvasKeyFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userCanvasKey);
  }
}
