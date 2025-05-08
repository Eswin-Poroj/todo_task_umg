class Task {
  int? id;
  int userId;
  String title;
  String details;
  String? dueDatetime;
  int isFavorite;
  String status;
  int priority;

  Task({
    this.id,
    required this.userId,
    required this.title,
    required this.details,
    this.dueDatetime,
    required this.isFavorite,
    required this.status,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "title": title,
      "details": details,
      "due_datetime": dueDatetime,
      "is_favorite": isFavorite,
      "status": status,
      "priority": priority,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      details: json['details'],
      dueDatetime: json['due_datetime'],
      isFavorite: json['is_favorite'],
      status: json['status'],
      priority: json['priority'],
    );
  }
}
