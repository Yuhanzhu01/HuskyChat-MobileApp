import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hchat/pages/chat_home_page.dart';
import 'package:hchat/pages/search_page.dart';
import 'package:hchat/widgets/widgets.dart';
import 'package:mockito/mockito.dart';

const GroupsCollection = 'groups';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('Chat Home Page Tests', () {
    //setUp(() {}); // setUp()
    testWidgets('ChatHomePage Display', (WidgetTester widgetTester) async {
      final firestore = FakeFirebaseFirestore();
      await firestore.collection(GroupsCollection).add({
        'admin': 'vxVp6ojx3ycPYGtp27XgBkUSsiY2_newUser',
        'groupIcon': '',
        'groupId': '2qtxmsgl8pRLtDFWqGPI',
        'groupName': 'Valorant Lineups',
        'members': [],
        'recentMessage': '',
        'recentMessageSender': ''
      });

      await widgetTester.pumpWidget(MaterialApp(
        home: ChatHomePage(firestore: firestore),
      ));

      // await widgetTester.pumpWidget(const MaterialApp(
      //   home: ChatHomePage(),
      // ));

      //expect(find.byWidget(noGroupWidget), matcher)
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
    testWidgets('Hitting the search page', (WidgetTester widgetTester) async {
      final res = '123_abc';
      final firestore = FakeFirebaseFirestore();
      await firestore.collection(GroupsCollection).add({
        'admin': 'vxVp6ojx3ycPYGtp27XgBkUSsiY2_newUser',
        'groupIcon': '',
        'groupId': '2qtxmsgl8pRLtDFWqGPI',
        'groupName': 'Valorant Lineups',
        'members': [],
        'recentMessage': '',
        'recentMessageSender': ''
      });

      await widgetTester.pumpWidget(MaterialApp(
        home: ChatHomePage(
          firestore: firestore,
        ),
      ));
      await widgetTester.tap(find.byIcon(Icons.search));
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Testing build of page', (WidgetTester widgetTester) async {
      //final res = '123_abc';
      final firestore = FakeFirebaseFirestore();
      await firestore.collection(GroupsCollection).add({
        'admin': 'vxVp6ojx3ycPYGtp27XgBkUSsiY2_newUser',
        'groupIcon': '',
        'groupId': '2qtxmsgl8pRLtDFWqGPI',
        'groupName': 'Valorant Lineups',
        'members': [],
        'recentMessage': '',
        'recentMessageSender': ''
      });

      await widgetTester.pumpWidget(MaterialApp(
        home: ChatHomePage(
          firestore: firestore,
        ),
      ));
      await widgetTester.tap(find.byIcon(Icons.search));
      expect(find.byIcon(Icons.search), findsOneWidget);

      // expect(
      //     find.text(
      //         "You haven't joined any groups, tap on the add icon to create a group or also search from top search button"),
      //     findsNothing);
    });
    testWidgets('Pop up dialog should be displayed',
        (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      // Arrange
      await tester.pumpWidget(MaterialApp(
        home: ChatHomePage(firestore: firestore),
      ));

      // Act
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      //await tester.pumpAndSettle(Duration(seconds: 10));

      // Assert
      expect(find.text('Create a Group'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });
  }); // group()
} // main()