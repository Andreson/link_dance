import 'dart:convert';

import 'package:link_dance/persistence/db.dart';
import 'package:sqflite/sqflite.dart' as sql;

class GenericDao {
  Future<void> insert(String table, Map<String, Object?> data) async {
    final db = await DbHelper.database;

    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<void> update(String table, Map<String, Object?> data) async {
    final db = await DbHelper.database;

    await db.update(
      table,
      data,
      where: 'id = ? ',
      whereArgs: [data["id"]],
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> executeQuery(String query) async {
    final db = await DbHelper.database;
    return db.rawQuery(query);
  }

  Future<List<Map<String, dynamic>>> selectAll(String tableName,
      [String? orderBySql]) async {
    final db = await DbHelper.database;
    if (orderBySql == null)
      return db.query(tableName);
    else
      return db.query(tableName, orderBy: orderBySql);
  }

  Future<int> count(String tableName) async {
    final db = await DbHelper.database;
    return sql.Sqflite.firstIntValue(
        await db.rawQuery("select max(id) as maxId from $tableName"))!;
  }

//faz um select count no ID e retorna o valor incrementado
//presupoem-se que o ID da tabela é "id"
  Future<int> nextId(String tableName) async {
    final db = await DbHelper.database;
    var maxid = sql.Sqflite.firstIntValue(
        await db.rawQuery("select max(id) as maxId from $tableName"));
    if (maxid == null) return 1;

    return (maxid) + 1;
  }

  void deleteAll(String tableName) async {
    final db = await DbHelper.database;
    await db.rawQuery("delete from  $tableName");
  }

  void delete(String tableName, Map<String, Object> params) async {
    final db = await DbHelper.database;

    var columsName = "";
    List<Object> values = [];
    params.forEach((key, value) {
      columsName = "$columsName ${key} = ? ,";
      values.add(value);
    });
    columsName = columsName.substring(0, columsName.length - 1);

    await db.rawDelete("delete from  $tableName where ${columsName}", values);
  }

  Future<List<Map<String, dynamic>>> find(
      String tableName, Map<String, Object> params) async {
    final db = await DbHelper.database;

    var columsName = "";
    List<Object> values = [];
    params.forEach((key, value) {
      columsName = "$columsName ${key} = ? ,";
      values.add(value);
    });
    columsName = columsName.substring(0, columsName.length - 1);

    return await db.rawQuery(
        "select  * from  $tableName where ${columsName}", values);
  }

  Future<List<Map<String, dynamic>>> findRaw(String sqlquery) async {
    final db = await DbHelper.database;

    return await db.rawQuery(sqlquery);
  }
}
