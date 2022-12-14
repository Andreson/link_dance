import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbHelper {
  static sql.Database? _databaseInstance;
  static final databaseName = "despesas.db";

  DbHelper._privateConstructor();

  static final DbHelper instance = DbHelper._privateConstructor();

  static final _tablesDdl = [
    //'DROP TABLE IF EXISTS conta ',
    'CREATE TABLE  IF NOT EXISTS  conta (id TEXT PRIMARY KEY,idMes TEXT ,idParent TEXT , titulo TEXT,subtitulo TEXT, dataVencimento TEXT, valor REAL, pago INTEGER)',
    //'DROP TABLE IF EXISTS   MES',
    'CREATE TABLE  IF NOT EXISTS  mes (id TEXT PRIMARY KEY,mes TEXT )',
    'CREATE TABLE  IF NOT EXISTS  contaRecorrent (id TEXT PRIMARY KEY,idConta TEXT )',
  ];

  static Future<sql.Database> get database async {
    if (_databaseInstance != null) {
      return _databaseInstance!;
    }

    _databaseInstance = await _initDatabase();
    _createTables();
    return _databaseInstance!;
  }

  static Future<sql.Database> _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, databaseName),
      version: 1,
    );
  }

  static Future _createTables() async {
    print("#### Criando novas tabelas ");
    _tablesDdl.forEach((tableSql) {
      print(tableSql);
      database.then((db) => db.execute(tableSql));
    });
    print("#### finalizando criação de novas tabelas ####### ");
  }
}
