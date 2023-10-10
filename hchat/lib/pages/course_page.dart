import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hchat/pages/Assignment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Course.dart';

/// This file defines the [CoursePage] widget that displays assignments for a given course.
/// The [CoursePage] widget is a [StatefulWidget] that takes in a [Course] object 
/// and displays a list of [Assignment] objects for that course.
class CoursePage extends StatefulWidget {
  final Course course;

  CoursePage({required this.course});

  @override
  _CoursePageState createState() => _CoursePageState();
}

/// The [_CoursePageState] class is the corresponding state class for [CoursePage], 
/// which includes a list of [_assignments] and a function [_getAssignments()] 
/// to retrieve and update assignments from the server.
class _CoursePageState extends State<CoursePage> {
  List<Assignment> _assignments = [];

  @override
  void initState() {
    super.initState();
    _getAssignments();
  }

/// The [_getAssignments()] function calls the [getAssignments()] function, 
/// which makes an HTTP request to the Canvas LMS API and retrieves a list of assignments for the given course.
  Future<void> _getAssignments() async {
    List<Assignment> assignments = await getAssignments();
    setState(() {
      _assignments = assignments;
    });
  }

/// The [getAssignments()] function, which makes an HTTP request to the Canvas LMS API
/// and retrieves a list of assignments for the given course.
  Future<List<Assignment>> getAssignments() async {
    print(widget.course.id);
    String url =
        'https://northeastern.instructure.com/api/v1/courses/${widget.course.id}/assignments';
    String accessToken =
        '14523~irQHIMpJbO0utZnmpHuYBz4oImuRu2UmCt0qrXvZMmDqTmK9Hxf7DOSoOnSmvg4N';
    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> assignmentsJson = jsonDecode(response.body);
      List<Assignment> assignments =
          assignmentsJson.map((json) => Assignment.fromJson(json)).toList();
      return assignments;
    } else {
      throw Exception('Failed to load assignments');
    }
  }

/// The [build()] function builds the user interface for the [CoursePage] widget. 
/// It includes an [AppBar] with the Northeastern University logo, a [Text] widget with the header "Assignments", 
/// and a [ListView.builder] that displays the list of [_assignments] as [Card] widgets with [ListTile] children that display information about each assignment, 
/// such as its name, due date, and status (submitted or pending).
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Semantics (
            label: 'NEU Husky Logo',
            child: Image.asset(
            'assets/huskypng.png',
            height: 60,
          ),
          )
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                Semantics(
                  label: 'Assignments',
                  child: const Text(
                    'Assignments',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _assignments.length,
                    itemBuilder: (context, index) {
                      final assignment = _assignments[index];
                      // assignment.deadline = DateTime.now().toURtc().toString();
                      DateTime dateTime = DateTime.parse(assignment.deadline);
                      DateTime pacificTime =
                          dateTime.subtract(Duration(hours: 8));
                      String date =
                          "${dateTime.day}-${dateTime.month}-${dateTime.year}";
                      String time =
                          "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
                      padding:
                      EdgeInsets.fromLTRB(0, 10, 0, 0);
                      return Card(
                        child: ListTile(
                          title: Semantics(
                            label: '${assignment.name}',
                            child: Text(
                              '${assignment.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(
                                label: "Due on: " + date + " " + time,
                                child: Text("Due on: " + date + " " + time),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Semantics(
                                    label: "Points: " + '${assignment.points}',
                                    child: Text(
                                      "Points: " + '${assignment.points}',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  assignment.isSubmitted
                                      ? Semantics(
                                        label: 'Submitted',
                                        child: Text(
                                          "Submitted",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      )
                                      : Semantics(
                                        child: Text(
                                          "Pending",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          semanticsLabel: 'Pending'
                                        )
                                      )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            )));
  }
}
