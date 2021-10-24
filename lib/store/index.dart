import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:task/store/task.dart';

class Store {
  static Future<void> init() async {
    await StoreTask.init();

    Directory appDocDir = await getApplicationDocumentsDirectory();
    var file = File('${appDocDir.path}/db.json');

    try {
      // await file.delete();
      await file.readAsString();
    } catch (e) {
      Map<String, dynamic> i = {
        "tasks": [],
      };

      await file.writeAsString(jsonEncode(i));
    }
  }

  static get(String key) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    var file = File('${appDocDir.path}/db.json');
    var db = jsonDecode(file.readAsStringSync());

    return db[key];
  }

  static save({required String key, dynamic value}) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    var file = File('${appDocDir.path}/db.json');
    var db = jsonDecode(file.readAsStringSync());

    try {
      db[key] = value;
      file.writeAsStringSync(jsonEncode(db));

      return db;
    } catch (e) {
      rethrow;
    }
  }
}
