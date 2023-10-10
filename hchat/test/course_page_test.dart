import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hchat/pages/Course.dart';
import 'package:hchat/pages/course_page.dart';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';

import 'package:nock/nock.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  final mockClient = MockClient();

    setUpAll(nock.init);

    setUp(() {
      nock.cleanAll();
    });

  testWidgets('CoursePage shows assignments', (WidgetTester tester) async {
    final assignmentsJson = [
      {
        "id": 1,
        "name": "Assignment 1",
        "points_possible": 10.0,
        "due_at": "2022-01-01T00:00:00Z",
        "has_submitted_submissions": true
      },
      {
        "id": 2,
        "name": "Assignment 2",
        "points_possible": 10.0,
        "due_at": "2022-01-01T00:00:00Z",
        "has_submitted_submissions": false
      }
    ];

      nock('https://northeastern.instructure.com').get('/api/v1/courses/1/assignments').reply(200, 
      json.encode(assignmentsJson));

    final course = Course(id: 1, name: 'Course A', courseCode: 'CS1222', term: 'Fall 2022', status: 'In Progress');
    await tester.pumpWidget(MaterialApp(
        home: CoursePage(
      course: course,
    )));

    await tester.pumpAndSettle();

    // Verify that the assignments are displayed
    expect(find.text('Assignments'), findsOneWidget);
    expect(find.text('Assignment 1'), findsOneWidget);
    // expect(find.'), findsOneWidget);
    expect(find.text('Submitted'), findsOneWidget);
    expect(find.text('Assignment 2'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);

    // expect(find.text('5'), findsOneWidget);
    // expect(find.text('2022-02-01'), findsOneWidget);
  });
}
