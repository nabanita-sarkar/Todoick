class Task {
  final int? id;
  final String title;
  final String? desc;
  Task({this.id, required this.title, this.desc});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'desc': desc};
  }
}
