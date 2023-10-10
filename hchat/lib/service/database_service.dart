import 'package:cloud_firestore/cloud_firestore.dart';

/// This is the DatabaseService class. This is the class that will
/// mainly be communicating with the Firestore Database.
class DatabaseService {
  late final String? uid;
  DatabaseService({this.uid});

  /// Reference for the collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  /// This method saves the user data given into the Firestore
  /// Database. Includes the userName, email, and accessKey
  /// for the user.
  Future savingUserData(
      String userName, String email, String canvasAccessKey) async {
    return await userCollection.doc(uid).set({
      "huskyChatUserName": userName,
      "myNortheasternEmail": email,
      "canvasAccessKey": canvasAccessKey,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  /// This method gets the user's data from the Firestore Database.
  /// Includes things such as the Canvas API Key, the Email,
  /// and the userName of the user.
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot = await userCollection
        .where("myNortheasternEmail", isEqualTo: email)
        .get();
    return snapshot;
  }

  /// This method returns the list of Groups that a user
  /// is a part of.
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  /// This method creates a Group given a userName, an Id, and a groupName
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // Update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  /// This method gets the chats for a specific Group given their
  /// groupId. They also get ordered by time as well.
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  /// This method gets the Admin of the group, which
  /// is displayed in the details of the group.
  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["admin"];
  }

  /// This method returns the members of a group given the groupId.
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  /// Searchs a group by a given groupName. The name has to equal the
  /// groupname exactly for it to be returned
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  /// Function to check if the user is in the group.
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot["groups"];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  /// Toggles whether someone joins or leaves the group. This is
  /// used to add or remove a user from a group in the chat function.
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot["groups"];

    /// If the user is currently in group, remove the group from their
    /// list of groups and remove the user from the list of members
    /// in the Group.
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  /// Adds a chat message to the collection messages. Also updates
  /// things in the group collection including the recentMessage,
  /// the recentMessageSender, and the recentMessageTime (The last
  /// of which is used to order messages).
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
