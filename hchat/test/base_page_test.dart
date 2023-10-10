import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hchat/pages/Course.dart';
import 'package:hchat/service/auth_service.dart';
import 'package:hchat/service/database_service.dart';
import 'package:mockito/mockito.dart';

import 'package:hchat/pages/base_page.dart';
import 'package:hchat/widgets/custom_app_bar.dart';
import 'package:hchat/pages/profile_page.dart';
import 'package:hchat/pages/chat_home_page.dart';
import 'package:hchat/pages/husky_home_page.dart';
import 'package:hchat/pages/testpages/notification_tap.dart';
import 'package:nock/nock.dart';

class MockAuthService extends Mock implements AuthService {}

class MockDatabaseService extends Mock implements DatabaseService {}

const GroupsCollection = 'groups';

void main() {
  group('BasePage widget tests', () {
    String url = 'https://northeastern.instructure.com//api/v1/courses';

    late List<Course> mockCourses;
    late Map<String, String> headers;
    setUpAll(nock.init);
    late BasePage basePage;

    setUp(() async {
      mockCourses = [
        Course(
            id: 1,
            name: 'Course 1',
            courseCode: 'CSC111',
            term: 'Fall',
            status: 'Completed'),
        Course(
            id: 2,
            name: 'Course 2',
            courseCode: 'CSC222',
            term: 'Spring',
            status: 'In Progress'),
      ];

      String accessToken =
          '14523~irQHIMpJbO0utZnmpHuYBz4oImuRu2UmCt0qrXvZMmDqTmK9Hxf7DOSoOnSmvg4N';
      headers = {'Authorization': 'Bearer $accessToken'};

      nock.cleanAll();
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

      final user = MockUser(
          isAnonymous: false,
          uid: 'someuid',
          email: 'bob@somedomain.com',
          displayName: 'Bob',
        );
    final auth = MockFirebaseAuth(mockUser: user);

      basePage = BasePage(
        firestore: firestore,
        firebaseAuth: auth,
      );
    });

    testWidgets('Test if BottomNavigationBar is shown',
        (WidgetTester tester) async {
      nock('https://northeastern.instructure.com/')
          .get('/api/v1/courses')
          .reply(
              200,
              json.encode([
                {
                  "id": 2,
                  "name": 'Course 2',
                  "course_code": 'CSC222',
                  "term": 'Spring',
                  "workflow_state": 'In Progress'
                },
                {
                  "id": 1,
                  "name": 'Course 1',
                  "course_code": 'CSC111',
                  "term": 'Spring',
                  "workflow_state": 'In Progress'
                }
              ]));
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

final user = MockUser(
          isAnonymous: false,
          uid: 'someuid',
          email: 'bob@somedomain.com',
          displayName: 'Bob',
        );
    final auth = MockFirebaseAuth(mockUser: user);
    
      await tester.pumpWidget(MaterialApp(
        home: BasePage(firestore: firestore, firebaseAuth: auth,),
      ));
      expect(find.text("Profile"), findsOneWidget);
      expect(find.text("Chat"), findsOneWidget);
      expect(find.text("Home"), findsOneWidget);
      expect(find.text("Notifications"), findsOneWidget);

      await tester.tap(find.text("Notifications"));
      await tester.tap(find.text("Chat"));
      await tester.tap(find.text("Home"));
      await tester.tap(find.text("Profile"));
    });
  });
}
