import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hchat/helper/helper_function.dart';
import 'package:hchat/pages/auth/login_page.dart';
import 'package:hchat/pages/chat_home_page.dart';
import 'package:hchat/service/auth_service.dart';
import 'package:hchat/service/database_service.dart';
import 'package:hchat/widgets/widgets.dart';

/// This is the ProfilePage for HuskyChat should show the users
/// a few things about their profile including their username,
/// their school email, and their CanvasAccessKey.
class ProfilePage extends StatefulWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ProfilePage({Key? key, required this.firestore, required this.firebaseAuth})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState(this.firebaseAuth);
}

/// ProfilePageState, shows information specific to the user.
/// This also has a static photo which can be updated to
/// include a real photo if needed. Currently holds some extra
/// logic from a tutorial but will proabably be cut. This
/// has to do with the drawer.
class _ProfilePageState extends State<ProfilePage> {
  late FirebaseAuth firebaseAuth;
  String huskyChatUserName = '';
  String myNortheasternEmail = '';
  String canvasAccessKey = '';
  String shortAccessKey = '';
  String groupName = '';
  Stream? groups;
  late AuthService authService;

  _ProfilePageState(FirebaseAuth firebaseAuth) {
    this.firebaseAuth = firebaseAuth;
    authService = new AuthService.fromParam(this.firebaseAuth);
  }

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // coverage:ignore-start
  /// Gets the users data that is saved locally.
  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        myNortheasternEmail = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        huskyChatUserName = val!;
      });
    });
    await HelperFunctions.getCanvasKeyFromSF().then((v) {
      setState(() {
        canvasAccessKey = v!;
        shortAccessKey = canvasAccessKey.substring(0, 5);
      });
    });
    // Getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }
  // coverage:ignore-end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              huskyChatUserName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            // ListTile(
            //   onTap: () {
            //     nextScreen(context, ChatHomePage(firestore: firestore,));
            //   },
            //   contentPadding:
            //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            //   leading: const Icon(Icons.group),
            //   title: const Text(
            //     "Groups",
            //     style: TextStyle(color: Colors.black),
            //   ),
            // ),
            ListTile(
              onTap: () {},
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () async {
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ))
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.account_circle,
                size: 200,
                color: Colors.grey[700],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Username",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    huskyChatUserName,
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    myNortheasternEmail,
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Canvas Key",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "${shortAccessKey}",
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
