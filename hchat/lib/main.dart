import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hchat/helper/helper_function.dart';
import 'package:hchat/pages/auth/login_page.dart';
import 'package:hchat/pages/base_page.dart';
import 'package:hchat/pages/chat_home_page.dart';
import 'package:hchat/pages/home_page.dart';
import 'package:hchat/shared/constants.dart';

/// Main for the HuskyChat project. This part ensures that the app
/// will run on both phones and the computer with a connection to
/// Firebase.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final FirebaseFirestore firestore;

  // CollectionReference get groups => firestore.collection('groups');

  runApp(const MyApp());
}

/// Creates the main body of the application as well as its state.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

/// Sets signed in to be false and then checks the users logged
/// in status, which could updates the _isSignedIn boolean.
class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  var firestore;
  // late FirebaseAuth firebaseAuth;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
    var app;
    setupFirebase(app);
  }

  setupFirebase(var app) async {
    if (kIsWeb) {
      // Run the Web Initialization for web
      app = await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: Constants.apiKey,
              appId: Constants.appId,
              messagingSenderId: Constants.messagingSenderId,
              projectId: Constants.projectId));
    } else {
      // Run the Android and iOS Initiatlization
      app = await Firebase.initializeApp();
    }

    firestore = FirebaseFirestore.instanceFor(app: app);
    // firebaseAuth = FirebaseAuth.instance;
  }

  /// Calls a helper function to check the logged in status of the user.
  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  /// This is what will run when HuskyChat is ran. Returns the MaterialApp.
  /// Has some Theme data, which makes scaffoldBackground color white and
  /// calls the primaryColor Constant
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Constants().primaryColor,
          scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ? BasePage(firestore: firestore, firebaseAuth: FirebaseAuth.instance) : const LoginPage(),
    );
  }
}
