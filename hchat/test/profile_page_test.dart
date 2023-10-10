import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hchat/main.dart';
import 'package:hchat/pages/chat_home_page.dart';
import 'package:hchat/pages/profile_page.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

const MessagesCollection = 'messages';
const UserCollection = 'users';

void main() {
  testWidgets('shows messages', (WidgetTester tester) async {
    // Populate the fake database.
    final firestore = FakeFirebaseFirestore();
    await firestore.collection(UserCollection).add({
      'canvasAccessKey':
          '14523~irQHIMpJbO0utZnmpHuYBz4oImuRu2UmCt0qrXvZMmDqTmK9Hxf7DOSoOnSmvg4N',
      'huskyChatUserName': 't1',
      'myNortheasternEmail': 't1@gmail.com',
      'uid': 'NDfgtg1dvSc3knZqdrMSxg5LxKl2'
    });

    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user);

    await tester.pumpWidget(MaterialApp(
      home: ProfilePage(
        firestore: firestore,
        firebaseAuth: auth,
      ),
    ));

    // final ScaffoldState state = tester.firstState(find.byType(Scaffold));
    // state.openDrawer();
    // await tester.pump();
    // expect(find.byType(ListTile), findsNWidgets(2));
    // await tester.tap(find.byIcon(Icons.cancel));
    //await tester.pump();

    //await tester.tap(find.byType(Drawer));
    //await tester.tap(find.text('Logout'));
    //expect(find.byType(ListTile), findsNWidgets(2));
    // Let the snapshots stream fire a snapshot.
    // await tester.idle();
    // Re-render.

    // testWidgets('ProfilePage UI Test', (WidgetTester tester) async {
    //   await tester.pumpWidget(MaterialApp(home: ProfilePage()));
    // });

    // final appBarTitleFinder = find.text('Profile');
    // expect(appBarTitleFinder, findsOneWidget);

    // Drawer menu test
    // final groupsFinder = find.text('Groups');
    // expect(groupsFinder, findsOneWidget);

    // final profileFinder = find.text('Profile');
    // expect(profileFinder, findsOneWidget);

    // final logoutFinder = find.text('Logout');
    // expect(logoutFinder, findsOneWidget);

    // // User information test
    // final usernameFinder = find.text('Username');
    // expect(usernameFinder, findsOneWidget);

    // final canvasKeyFinder = find.text('Canvas Access Key');
    // expect(canvasKeyFinder, findsOneWidget);

    // // Photo test
    // final photoFinder = find.byIcon(Icons.account_circle);
    // expect(photoFinder, findsNWidgets(2)); // one in drawer, one in body

    // // Tap menu items test
    // await tester.tap(groupsFinder);
    // await tester.pumpAndSettle();
    // expect(find.byType(ChatHomePage), findsOneWidget);

    // // Render the widget.
    // await tester.pumpWidget(MaterialApp(
    //     title: 'Firestore Example', home: MyHomePage(firestore: firestore)));
    // // Let the snapshots stream fire a snapshot.
    // await tester.idle();
    // // Re-render.
    // await tester.pump();
    // // // Verify the output.
    // expect(find.text('Hello world!'), findsOneWidget);
    // expect(find.text('Message 1 of 1'), findsOneWidget);
  });
}
