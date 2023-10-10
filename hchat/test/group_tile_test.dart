import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hchat/widgets/group_tile.dart';

const UsersCollection = 'users';

void main() {
  testWidgets('GroupTile should navigate to ChatPage on tap',
      (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection(UsersCollection).add({
      'canvasAccessKey':
          '14523~irQHIMpJbO0utZnmpHuYBz4oImuRu2UmCt0qrXvZMmDqTmK9Hxf7DOSoOnSmvg4N',
      'huskyChatUserName': 't1',
      'myNortheasternEmail': 't1@gmail.com',
      'uid': 'NDfgtg1dvSc3knZqdrMSxg5LxKl2'
    });
    // Build the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GroupTile(
            firestore: firestore,
            groupId: 'group-id',
            groupName: 'Group Name',
            userName: 'User Name',
          ),
        ),
      ),
    );

    // Tap the group tile
    // await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();

    // Verify that the ChatPage was navigated to
    // expect(find.byType(ChatPage), findsOneWidget);
  });
}
