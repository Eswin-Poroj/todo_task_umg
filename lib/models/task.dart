import 'dart:convert';

class Task {
  late final int? id;
  late final int userId;
  late String title;
  late String details;
  late String dueDatetime;
  late int isFavorite;
  late String status;
  late int priority;

  Task({
    this.id,
    required this.userId,
    required this.title,
    required this.details,
    required this.dueDatetime,
    required this.isFavorite,
    required this.status,
    required this.priority,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      details: json['details'] ?? '',
      dueDatetime: json['due_datetime'] ?? DateTime.now().toIso8601String(),
      isFavorite: json['fav'] == true || json['fav'] == 1 ? 1 : 0,
      status: json['status'] ?? 'pendiente',
      priority: json['prio'] ?? 1,
    );
  }

  String toJson() {
    return jsonEncode({
      'user_id': userId,
      'title': title,
      'desc': details,
      'due_datetime': dueDatetime,
      'fav': isFavorite == 1,
      'status': status,
      'prio': priority,
    });
  }
}
