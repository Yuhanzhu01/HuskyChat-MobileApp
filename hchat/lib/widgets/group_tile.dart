import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hchat/pages/chat_page.dart';
import 'package:hchat/widgets/widgets.dart';

/// GroupTile class that will hold the groups shown on
/// the ChatHomePage screen. Requires a groupId, groupName, and
/// the userName of the current user.
class GroupTile extends StatefulWidget {
  final FirebaseFirestore firestore;

  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile(
      {Key? key,
      required this.firestore,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

/// GroupTileState for the GroupTile class. If a tile is clicked,
/// the app sends the user to the ChatPage for said Group. Has a
/// fixed avatar with the first letter of the group name, the name
/// of the group, and lets you know who you can join the conversation as.
class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              firestore: widget.firestore,
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
              radius: 30,
              backgroundColor:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              child: Text(
                widget.groupName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
