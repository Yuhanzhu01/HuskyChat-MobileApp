/// A class representing an assignment in a course.
class Assignment {
  /// The unique identifier of the assignment.
  final int id;

  /// The name of the assignment.
  final String name;

  /// The deadline for the assignment.
  String deadline;

  /// The number of points the assignment is worth.
  final double points;

  /// A flag indicating if the assignment has been submitted or not.
  final bool isSubmitted;

/// Creates a new instance of [Assignment] with the given properties.
  Assignment(
      {required this.id,
      required this.name,
      required this.deadline,
      required this.points,
      required this.isSubmitted});

/// Creates a new instance of [Assignment] from a JSON map.
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      name: json['name'],
      deadline: json['due_at'],
      points: json['points_possible'],
      isSubmitted: json['has_submitted_submissions'],
    );
  }
}
