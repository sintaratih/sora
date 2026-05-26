class Task {
  String id;
  String title;
  String note;
  DateTime dateTime;

  bool isDone;
  bool isAllDay;

  String? categoryColor; // contoh: blue, red, green
  int priority; // 0 = low, 1 = medium, 2 = high

  DateTime createdAt;
  DateTime? updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.note,
    required this.dateTime,
    this.isDone = false,
    this.isAllDay = false,
    this.categoryColor,
    this.priority = 0,
    required this.createdAt,
    this.updatedAt,
  });

  // 🔥 Convert ke Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "note": note,
      "dateTime": dateTime.toIso8601String(),
      "isDone": isDone,
      "isAllDay": isAllDay,
      "categoryColor": categoryColor,
      "priority": priority,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }

  // 🔥 Dari Firestore ke model
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map["id"],
      title: map["title"],
      note: map["note"],
      dateTime: DateTime.parse(map["dateTime"]),
      isDone: map["isDone"] ?? false,
      isAllDay: map["isAllDay"] ?? false,
      categoryColor: map["categoryColor"],
      priority: map["priority"] ?? 0,
      createdAt: DateTime.parse(map["createdAt"]),
      updatedAt: map["updatedAt"] != null
          ? DateTime.parse(map["updatedAt"])
          : null,
    );
  }
}