// ignore_for_file: file_names

class ITask {
  String id;
  String title;
  String? description;
  DateTime datetime;

  ITask({
    required this.id,
    required this.title,
    this.description,
    required this.datetime,
  });

  factory ITask.fromJson(Map<String, dynamic> json) {
    return ITask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      datetime: DateTime.parse(json['datetime']),
    );
  }

  dynamic get toJson {
    return {
      'id': id,
      'title': title,
      'description': description,
      'datetime': datetime.toString(),
    };
  }
}
