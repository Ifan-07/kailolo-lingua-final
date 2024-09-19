// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      isPriority: json['isPriority'] as bool,
      isDone: json['isDone'] as bool,
      progress: (json['progress'] as num).toDouble(),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isPriority': instance.isPriority,
      'isDone': instance.isDone,
      'progress': instance.progress,
    };
