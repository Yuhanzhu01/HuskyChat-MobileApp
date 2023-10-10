import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Course.dart';
import 'dart:math';

import 'course_page.dart';

/// HuskyHomePage represents the home page of the Husky app, which displays
/// a grid of courses. Each course is represented by a [Card] widget that displays
/// the course name and course code, and when tapped, opens a new [CoursePage] widget
/// to display detailed information about the course.
class HuskyHomePage extends StatefulWidget {
  @override
  _HuskyHomePageState createState() => _HuskyHomePageState();
}

class _HuskyHomePageState extends State<HuskyHomePage> {
  /// A list of [Course] objects to be displayed on the home page.
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _getCourses();
  }

/// Fetches the list of courses from the API and updates [_courses] with the result.
  Future<void> _getCourses() async {
    List<Course> courses = await getCourses();
    setState(() {
      _courses = courses;
    });
  }

/// Makes an API call to fetch the list of courses.
  Future<List<Course>> getCourses() async {
    String url = 'https://northeastern.instructure.com//api/v1/courses';
    String accessToken =
        '14523~irQHIMpJbO0utZnmpHuYBz4oImuRu2UmCt0qrXvZMmDqTmK9Hxf7DOSoOnSmvg4N';
    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      // The API call was successful, parse the JSON response.
      List<dynamic> coursesJson = jsonDecode(response.body);
      List<Course> courses =
          coursesJson.map((json) => Course.fromJson(json)).toList();
      return courses;
    } else {
      // The API call failed, handle the error.
      throw Exception('Failed to load courses: ${response.statusCode}');
    }
  }

/// Generates a random color for the background of each course [Card].
  Color _getRandomColor() {
    Random random = new Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: GridView.count(
            crossAxisCount: 2,
            children: _courses.map((course) {
              return Semantics(
                label: '${course.name} ${course.courseCode}',
                child: AspectRatio(
                aspectRatio: 1.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CoursePage(course: course)));
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: _getRandomColor(),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(course.name
                            .substring(0, min(course.name.length, 25)),
                            semanticsLabel: course.name,),
                        SizedBox(height: 8),
                        Text(course.courseCode, 
                        semanticsLabel: course.courseCode,),
                      ],
                    ),
                  ),
                ),
              ),
              );
            }).toList(),
          )),
    );
  }
}