import 'dart:convert';
import 'package:dictionary/pages/catatan/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<int> getTaskId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('TaskId') ?? 0;
  }

  Future<void> updateTaskId(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('TaskId', id);
  }

  Future<Task> createTask(String title, String description, bool isPriority,
      bool isDone, double progress) async {
    final int lastId = await getTaskId();
    final int newId = lastId + 1;
    await updateTaskId(newId);
    return Task(
        id: newId,
        title: title,
        description: description,
        isPriority: isPriority,
        isDone: isDone,
        progress: progress);
  }

  Future<void> savePriorityItems(List<Task> items) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList =
        items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('priorityItems', stringList);
  }

  Future<List<Task>> loadPriorityItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList = prefs.getStringList('priorityItems') ?? [];
    List<Task> items = stringList
        .map((itemStr) => Task.fromJson(jsonDecode(itemStr)))
        .toList();
    return items;
  }

  Future<void> saveDailyItems(List<Task> items) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList =
        items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('dailyItems', stringList);
  }

  Future<List<Task>> loadDailyItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList = prefs.getStringList('dailyItems') ?? [];
    List<Task> items = stringList
        .map((itemStr) => Task.fromJson(jsonDecode(itemStr)))
        .toList();
    return items;
  }
}
