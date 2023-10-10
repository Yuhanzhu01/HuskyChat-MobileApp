import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hchat/helper/helper_function.dart';
import 'package:hchat/pages/chat_page.dart';
import 'package:hchat/service/database_service.dart';
import 'package:hchat/widgets/group_tile.dart';
import 'package:hchat/widgets/widgets.dart';

/// This is the search page that will be used to find different
/// chat groups within HuskyChat.
class SearchPage extends StatefulWidget {
  final FirebaseFirestore firestore;

  const SearchPage({Key? key, required this.firestore}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

/// SearchPageState for the SearchPage. This is where the page will
/// be built, holding the styling of the class and various helper
/// functions to get information needed from what is retrieved
/// from the database.
class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false;
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  /// Calls a Helper function to help get the username of the
  /// user and set a User to be equal to the currentUser of the app.
  getCurrentUserIdandName() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  /// String splicing method that will be used to get the
  /// admin name from the admin field in the Firestore Database.
  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  /// String splicing method that will be used to get the
  /// groupId from the admin field in the Firestore Database.
  /// (NOTE: Not used on this page so commented out, but
  /// nice to have if you did want the groupID)
  // String getId(String res) {
  //   return res.substring(0, res.indexOf("_"));
  // }

  /// Build for the SearchPage. Includes an AppBar and a body
  /// consisting of the search contents if they exist.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/huskypng.png',
          height: 60,
        ),
      ),
      body: Semantics(
        label:
            "Column for the page including an input bar for searching for groups and a container for any resulting groups from the search.",
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      label: "Input bar to search for groups",
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: "Search Groups. . .",
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearchMethod();
                    },
                    child: Semantics(
                      label:
                          "Circle button to search for the group you are looking for.",
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.black)),
                        child: const Icon(
                          Icons.search,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Semantics(
                    label:
                        "Loading icon if the page is still searching or if you ran into a problem.",
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  )
                : groupList(),
          ],
        ),
      ),
    );
  }

  /// Method to initiate the search method. Checks to see if the
  /// input isn't empty which sets the isLoading state to be true.
  /// Then the search content will be set to a local variable,
  /// isLoading set to false, and hasUserSearched equal to true,
  /// updating the container in the page.
  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  /// If the user has searched, then it will return groups that equal
  /// the search in the form of a List of groupTiles. If not, then a
  /// blank Container is returned.
  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index]['groupId'],
                searchSnapshot!.docs[index]['groupName'],
                searchSnapshot!.docs[index]['admin'],
              );
            },
          )
        : Container();
  }

  /// Checks if the user is joined to a group, and sets that
  /// value to the isJoined variable.
  joinedOrNot(
      String userName, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  /// This is the groupTile that will appear on the Search Page.
  /// It has the name of the group, the admin name of the group
  /// and a button on the side that you can click to join or
  /// leave the group. If pressed, a confirmation will pop up at
  /// the bottom letting you know that you have either joined or
  /// left the group and the group will be taken out of your
  /// ChatHomePage list of groups you can join in on to talk.
  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    // Function to check if user in group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.red,
          child: Text(
            groupName.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(groupName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Admin: ${getName(admin)}"),
        trailing: InkWell(
          onTap: () async {
            await DatabaseService(uid: user!.uid)
                .toggleGroupJoin(groupId, userName, groupName);
            if (isJoined) {
              setState(() {
                isJoined = !isJoined;
              });
              showSnackBar(context, Colors.green, "Successfully joined group!");
              Future.delayed(const Duration(seconds: 2), () {
                if (isJoined) {
                  nextScreen(
                      context,
                      ChatPage(
                          firestore: widget.firestore,
                          groupId: groupId,
                          groupName: groupName,
                          userName: userName));
                }
              });
            } else {
              setState(() {
                isJoined = !isJoined;
                showSnackBar(context, Colors.red, "Left the group $groupName");
              });
            }
          },
          child: isJoined
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text(
                    "Joined",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text(
                    "Join",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ));
  }
}
