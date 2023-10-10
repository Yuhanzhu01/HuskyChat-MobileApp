/// A class representing a course.
class Course {
  /// The id of the course.
  final int id;

  /// The name of the course.
  final String name;

  /// The code of the course.
  final String courseCode;

  /// The term of the course.
  final String? term;

  /// The status of the course.
  final String? status;

/// Creates a new [Course] instance.
/// The [id], [name], [courseCode], [term], and [status] parameters are required.
  Course(
      {required this.id,
      required this.name,
      required this.courseCode,
      required this.term,
      required this.status});

/// Creates a [Course] instance from a JSON [Map].
/// The [Map] must have the following keys: id, name, course_code, term, and workflow_state.
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      courseCode: json['course_code'],
      term: json['term'],
      status: json['workflow_state'],
    );
  }
}
