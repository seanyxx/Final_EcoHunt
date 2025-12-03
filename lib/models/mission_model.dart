class Mission {
  String title;
  bool completed;
  int points;
  DateTime date;

  Mission({
    required this.title,
    this.completed = false,
    this.points = 10,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  // Convert Mission object to Map (for local storage)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completed': completed,
      'points': points,
      'date': date.toIso8601String(),
    };
  }

  // Create Mission object from Map
  factory Mission.fromMap(Map<String, dynamic> map) {
    return Mission(
      title: map['title'],
      completed: map['completed'],
      points: map['points'],
      date: DateTime.parse(map['date']),
    );
  }
}
