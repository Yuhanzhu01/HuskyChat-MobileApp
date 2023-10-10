import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/src/fake_cloud_firestore_instance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hchat/helper/helper_function.dart';
import 'package:hchat/pages/auth/login_page.dart';
import 'package:hchat/pages/profile_page.dart';
import 'package:hchat/pages/search_page.dart';
import 'package:hchat/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:hchat/service/database_service.dart';
import 'package:hchat/widgets/group_tile.dart';
import 'package:hchat/widgets/widgets.dart';

/// ChatHomePage that will be used in the HuskyChat App.
class ChatHomePage extends StatefulWidget {
  final FirebaseFirestore firestore;

  const ChatHomePage({Key? key, required this.firestore}) : super(key: key);

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

///ChatHomePageState that will be updated and present the
///groups the user is currently a part of.
class _ChatHomePageState extends State<ChatHomePage> {
  String userName = "";
  String email = "";
  String canvasKey = "";
  // AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  /// String splicing method to return the former part
  /// of a String after an underscore.
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  /// String splicing method to return the latter part
  /// of a String after an underscore.
  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  /// Gets the users data that is saved locally.
  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    await HelperFunctions.getCanvasKeyFromSF().then((v) {
      setState(() {
        canvasKey = v!;
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

  /// ChatHomePage build where the page is made. Has an AppBar
  /// that is subject to change (shouldn't have an app bar
  /// if it is updated correctly). Shows the groups you are
  /// a part of unless you aren't a part of any. Also has
  /// a button used to create a group.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Colors.black,
              height: 4.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        centerTitle: false,
        title: InkWell(
          onTap: () {
            nextScreen(
                context,
                SearchPage(
                  firestore: widget.firestore,
                ));
          },
          child: const Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.search),
                ),
                TextSpan(
                    text:
                        '                                                                 '),
              ],
            ),
          ),
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  /// This creates a box that will pop up and let the user create
  /// a group. It won't go away unless you create a button or
  /// close the window.
  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a Group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackBar(
                          context, Colors.green, "Group created successfully!");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("Create"),
                )
              ],
            );
          }));
        });
  }

  /// This method gets a list of the Groups that the user is
  /// currently a part of.
  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // Make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      firestore: widget.firestore,
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['huskyChatUserName']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  /// This is a widget that will pop up when you haven't joined a
  /// group yet, prompting you to join one from the top by
  /// searching, or creating your own using the plus button.
  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You haven't joined any groups, tap on the add icon to create a group or also search from top search button",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
