import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:task/interfaces/ITask.dart';

class StoreTask {
  static Future<void> init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    var file = File('${appDocDir.path}/tasks.json');

    if (!(await file.exists())) {
      await file.writeAsString(jsonEncode([]));
    }
  }

  static Future<ITask?> getOne(String id) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    File file = File('${appDocDir.path}/tasks.json');
    List tasks = jsonDecode(file.readAsStringSync());
    int index = tasks.indexWhere((tk) => tk['id'].toString() == id);

    if (index != -1) {
      return ITask.fromJson(tasks[index]);
    }

    return null;
  }

  static Future<List<ITask>> getAll() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    var file = File('${appDocDir.path}/tasks.json');
    List tks = jsonDecode(file.readAsStringSync());
    var tasks = tks.map((dt) => ITask.fromJson(dt)).toList();

    tasks.sort((a, b) {
      return a.datetime.isAfter(b.datetime)
          ? -1
          : a.datetime.isBefore(b.datetime)
              ? 1
              : 0;
    });

    return tasks;
  }

  static Future<ITask?> save(ITask task) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    File file = File('${appDocDir.path}/tasks.json');
    List tasks = jsonDecode(file.readAsStringSync());
    int index = tasks.indexWhere((tk) => tk['id'] == task.id);

    if (index == -1) {
      tasks.add(task.toJson);
    } else {
      tasks[index] = task.toJson;
    }

    try {
      file.writeAsStringSync(jsonEncode(tasks));
      return task;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> remove(String id) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    File file = File('${appDocDir.path}/tasks.json');
    List tasks = jsonDecode(file.readAsStringSync());
    int index = tasks.indexWhere((tk) => tk['id'].toString() == id);

    tasks.removeAt(index);

    try {
      file.writeAsStringSync(jsonEncode(tasks));
    } catch (e) {
      rethrow;
    }
  }
}
