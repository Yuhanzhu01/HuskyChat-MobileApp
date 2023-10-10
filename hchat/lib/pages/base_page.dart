import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hchat/helper/helper_function.dart';
import 'package:hchat/pages/chat_home_page.dart';
import 'package:hchat/pages/home_page.dart';
import 'package:hchat/pages/husky_home_page.dart';
import 'package:hchat/pages/profile_page.dart';
// import 'package:hchat/pages/testpages/test_page3.dart';
import 'package:hchat/service/auth_service.dart';
import 'package:hchat/service/database_service.dart';
import 'package:hchat/widgets/custom_app_bar.dart';
import 'package:hchat/pages/testpages/notification_tap.dart';

/// BasePage that a user will see after
/// Logging in/registering.
class BasePage extends StatefulWidget {
  BasePage({super.key, required this.firestore, required this.firebaseAuth});

  final FirebaseFirestore firestore;
  late FirebaseAuth firebaseAuth;

  @override
  State createState() => _BasePageState(firestore, firebaseAuth);
}

/// BasePageState that will build and host the
/// visual changes of the Base Page.
class _BasePageState extends State<BasePage> {
  int currentIndex = 2;
  final FirebaseFirestore firestore;
  late FirebaseAuth firebaseAuth;
  _BasePageState(this.firestore, this.firebaseAuth);

  var screens = [];
  @override
  void initState() {
    // gettingUserData();
    super.initState();
    screens = [
      ProfilePage(firestore: firestore, firebaseAuth: firebaseAuth),
      ChatHomePage(
        firestore: firestore,
      ),
      HuskyHomePage(),
      // const HomePage(),
      NotificationTap(),
    ];
  }

  /// Screens that will be used in the base page. Depending on what
  /// BottomNavBarItem you press, it will be reflected by one of the
  /// screens below.

  /// Build for the BasePage. Has the CustomAppBar made in a
  /// different file as well as a BottomNavigationBar. The Body
  /// is a different screen depending on what BottomNavBarItem
  /// you have hit.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const CustomAppBar(),
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.red,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
