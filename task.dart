class Task {
  final String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;
  String category;
  String priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.category,
    required this.priority,
  });
}
