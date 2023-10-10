import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hchat/pages/Course.dart';
import 'package:hchat/pages/course_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mockito/mockito.dart';

import 'package:hchat/pages/husky_home_page.dart';

import 'package:nock/nock.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('HuskyHomePage widget', () {
    late MockHttpClient mockHttpClient;
    late List<Course> mockCourses;
    late Map<String, String> headers;
    
    String url = 'https://northeastern.instructure.com//api/v1/courses';

    setUpAll(nock.init);

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockCourses = [ Course(id: 1, name: 'Course 1', courseCode: 'CSC111', term: 'Fall', status: 'Completed'), 
      Course(id: 2, name: 'Course 2', courseCode: 'CSC222', term: 'Spring', status: 'In Progress'),];
      
      String accessToken =
        '14523~irQHIMpJbO0utZnmpHuYBz4oImuRu2UmCt0qrXvZMmDqTmK9Hxf7DOSoOnSmvg4N';
      headers = {'Authorization': 'Bearer $accessToken'};

      nock.cleanAll();
    });

    testWidgets('displays courses when they have loaded',
        (WidgetTester tester) async {

      nock('https://northeastern.instructure.com/').get('/api/v1/courses').reply(200, 
      json.encode([{"id": 2, "name": 'Course 2', "course_code": 'CSC222', "term": 'Spring', "workflow_state": 'In Progress'}, 
      {"id": 1, "name": 'Course 1', "course_code": 'CSC111', "term": 'Spring', "workflow_state": 'In Progress'}]));

      await tester.pumpWidget(MaterialApp(home: HuskyHomePage()));

      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.pump(Duration.zero);

      expect(find.text('CSC222'), findsOneWidget);
      expect(find.text('CSC111'), findsOneWidget);
      expect(find.text('Course 1'), findsOneWidget);
      expect(find.text('Course 2'), findsOneWidget);

      expect(find.bySemanticsLabel('Course 1 CSC111'), findsOneWidget);
    });

    testWidgets('navigates to course page when course is tapped',
        (WidgetTester tester) async {

      nock('https://northeastern.instructure.com/').get('/api/v1/courses').reply(200, 
      json.encode([{"id": 2, "name": 'Course 2', "course_code": 'CSC222', "term": 'Spring', "workflow_state": 'In Progress'}, 
      {"id": 1, "name": 'Course 1', "course_code": 'CSC111', "term": 'Spring', "workflow_state": 'In Progress'}]));

      await tester.pumpWidget(MaterialApp(home: HuskyHomePage()));

      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.pump(Duration.zero);

      expect(find.text('CSC222'), findsOneWidget);
      expect(find.text('CSC111'), findsOneWidget);
      expect(find.text('Course 1'), findsOneWidget);
      expect(find.text('Course 2'), findsOneWidget);

      await tester.tap(find.text('Course 1'));
    });

    testWidgets('test accessibility through sematic labels',
        (WidgetTester tester) async {

      nock('https://northeastern.instructure.com/').get('/api/v1/courses').reply(200, 
      json.encode([{"id": 2, "name": 'Course 2', "course_code": 'CSC222', "term": 'Spring', "workflow_state": 'In Progress'}, 
      {"id": 1, "name": 'Course 1', "course_code": 'CSC111', "term": 'Spring', "workflow_state": 'In Progress'}]));

      await tester.pumpWidget(MaterialApp(home: HuskyHomePage()));

      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.pump(Duration.zero);

      expect(find.bySemanticsLabel('Course 1 CSC111'), findsOneWidget);
      expect(find.bySemanticsLabel('Course 2 CSC222'), findsOneWidget);

    });

});
}