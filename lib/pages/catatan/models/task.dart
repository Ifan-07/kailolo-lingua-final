import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  int id;
  String title;
  String description;
  bool isPriority;
  bool isDone;
  double progress;
  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.isPriority,
      required this.isDone,
      required this.progress});

  // JSON serialization
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
