import 'dart:async';
import 'package:sql_lite/database/database.dart';
import 'package:sql_lite/Lista/lista.dart';

class Dao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createTodo(Lista todo) async {
    final db = await dbProvider.database;
    var result = db.insert(ListaTABLA, todo.toDatabaseJson());
    return result;
  }

  Future<List<Lista>> getTodos({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(ListaTABLA,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(ListaTABLA, columns: columns);
    }

    List<Lista> todos = result.isNotEmpty
        ? result.map((item) => Lista.fromDatabaseJson(item)).toList()
        : [];
    return todos;
  }

  Future<int> updateTodo(Lista todo) async {
    final db = await dbProvider.database;

    var result = await db.update(ListaTABLA, todo.toDatabaseJson(),
        where: "id = ?", whereArgs: [todo.id]);

    return result;
  }

  Future<int> deleteTodo(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(ListaTABLA, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future deleteAllTodos() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      ListaTABLA,
    );

    return result;
  }
}