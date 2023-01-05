import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:flutter/material.dart';

import '../model/abastract_model.dart';

abstract class BaseRepository<T extends AbastractModel> with ChangeNotifier {
  @protected
  late DocumentSnapshot<T> paginationPointer;
  List<QueryCondition>? _queryConditions;
  late String _orderBy;



// This should be the timestamp field in that document


  @protected
  int currentRegistryPagination = Constants.pageSize;
  @protected
  late RestTemplate restTemplate;

  List<T> listData = [];
  @protected
  late String collectionName;


  Future<List<T>?> nextPageBase({int? nextRegistry}) {
    var tempNextRegistry =
        nextRegistry ?? currentRegistryPagination + Constants.pageSize;
    currentRegistryPagination = tempNextRegistry;
    var response = listBase(
        nextPage: true,
        limit: tempNextRegistry,
        conditions: _queryConditions,
        orderBy: _orderBy);
    notifyListeners();
    return response;
  }

  @protected
  Future<Future<DocumentReference<Object?>>?> saveOrUpdateBase(
      {required Map<String, dynamic> data}) async {
    if (data['id'] != null && data['id'].toString().isNotEmpty) {
      updateBase(data: data);
      return null;
    } else {
      return saveBase(data: data);
    }
  }

  //salva um registro e adiciona ao lista de dados, nem atualiza os ouvintes
  @protected
  Future<Future<DocumentReference<Object?>>> saveBase(
      {required Map<String, dynamic> data}) async {
    data.removeWhere((key, value) => key == "id");
    var response = getCollectionBase(collectionName: collectionName).add(data);
    await response.then((value) {
      data["id"] = value.id;
      listData.insert(0, AbastractModel.jsonData(type: T, data: data) as T);
      notifyListeners();
    });
    return response;
  }


  //salva um registro mas  nao adiciona ao lista de dados, nem atualiza os ouvintes
  Future<void> saveSimple({required Map<String, dynamic> data}) async {
    data.removeWhere((key, value) => key == "id");
    var response = getCollectionBase(collectionName: collectionName).add(data);
    if (data['id'] != null) {
      updateBase(data: data);
    } else {
      await response.then((value) {});
    }
  }

  Future<void> updateBase({required Map<String, dynamic> data}) async {
    return getCollectionBase(collectionName: collectionName)
        .doc(data['id'])
        .update(data);
  }

  Future<void> removeBase({required String idDocument}) async {
    getCollectionBase(collectionName: collectionName).doc(idDocument).delete();
    listData.removeWhere((element) => element.id == idDocument);
    notifyListeners();
  }

  Future<T?> findByIdBase({required String documentId}) async {
    var response =
        await _queryRef(collectionName: collectionName).doc(documentId).get();
    return response.data();
  }

  @protected
  Future<List<T>?> likeSearchBase(
      {int limit = Constants.pageSize,
      bool nextPage = false,
      bool orderDesc = false,
      required QueryCondition condition,
      required String orderBy}) async {
    var textSearch = condition.contains!.trim();
    var reverseTerm = textSearch.split("").reversed.join("");
    var query = _queryRef(collectionName: collectionName)
        .where(condition.fieldName, isGreaterThanOrEqualTo: textSearch)
        .where(condition.fieldName, isLessThanOrEqualTo: "$reverseTerm\uf8ff")
        .limit(limit)
        .orderBy(orderBy, descending: orderDesc);
    print("Query likeSearchBase  ${query.parameters}");
    await _executeGenericQuery(
        query: query,
        conditions: [condition],
        limit: limit,
        nextPage: nextPage,
        orderBy: orderBy);

    notifyListeners();
    return listData;
  }

  void setNextPageParams(
      {List<QueryCondition>? conditions, required String orderBy}) {
    _queryConditions = conditions;
    _orderBy = orderBy;
  }


  Future<List<T>?> listBase(
      {int limit = Constants.pageSize,
      bool nextPage = false,
      List<QueryCondition>? conditions,
      bool orderDesc = true,
      bool notifyListen = true,
      String orderBy = "createDate"}) async {
    var query = _queryRef(collectionName: collectionName)
        .limit(limit)
        .orderBy(orderBy, descending: orderDesc);
    query = mapQueryCondition(conditions, query);


    //necessario esperar o resultado da chamada quando for chamar em seguida o notifyListener
    await _executeGenericQuery(
        query: query,
        conditions: conditions,
        limit: limit,
        nextPage: nextPage,
        orderBy: orderBy);

    if (notifyListen) notifyListeners();

    print("quantidade de resultados da consulta  ${listData.length}");
    return listData;
  }

  Future<List<T>?> _executeGenericQuery(
      {int limit = Constants.pageSize,
      bool nextPage = false,
      List<QueryCondition>? conditions,
      String orderBy = "createDate",
      required Query<T> query}) async {
    setNextPageParams(orderBy: orderBy, conditions: conditions);

    if (nextPage) {
      query = query.startAfterDocument(paginationPointer);
    } else {
      currentRegistryPagination = Constants.pageSize;
      clear();
    }

    var responseDocs = (await query.get()).docs;
    if (responseDocs.isNotEmpty) {
      paginationPointer = await responseDocs.last.reference.get();
      listData.addAll(responseDocs.map((item) => item.data()).toList());
    }
    return listData;
  }

  CollectionReference<T> _queryRef({required String collectionName}) {
    return getCollectionBase(collectionName: collectionName).withConverter<T>(
        fromFirestore: (snapshots, _) {
          return AbastractModel.json(type: T, snapshot: snapshots) as T;
        },
        toFirestore: (model, _) => (model as AbastractModel).body());
  }

  @protected
  CollectionReference getCollectionBase({required String collectionName}) {
    return FirebaseFirestore.instance.collection(collectionName);
  }

  @protected
  add(T item) {
    listData.add(item);
  }

  @protected
  clear() {
    listData.clear();
  }

  /**
   * Em alguns cenarios de busca, com filtros que nao retorna resposta, o Consumer tentar recriar os elementos
   * baseado na consulta anterior, que possuia resultados no listData que eles estao "ouvindo". Isso gera a quebra dos elementos
   * buildados que usam o listData.lengh para saber se existe elementos ou nao para serem mostrados
   */
  clearNotify() {
    listData.clear();
    notifyListeners();
  }

  Query<T> mapQueryCondition(List<QueryCondition>? conditions, Query<T> q) {
    if (conditions == null) {
      return q;
    }
    for (var condition in conditions) {
      if (condition.isEqualTo != null) {
        q = q.where(condition.fieldName, isEqualTo: condition.isEqualTo);
        continue;
      }
      if (condition.isNotEqualTo != null) {
        q = q.where(condition.fieldName, isNotEqualTo: condition.isNotEqualTo);
        continue;
      }
      if (condition.isLessThan != null) {
        q = q.where(condition.fieldName, isLessThan: condition.isLessThan);
        continue;
      }
      if (condition.isLessThanOrEqualTo != null) {
        q = q.where(condition.fieldName,
            isLessThanOrEqualTo: condition.isLessThanOrEqualTo);
        continue;
      }
      if (condition.isGreaterThan != null) {
        q = q.where(condition.fieldName,
            isGreaterThan: condition.isGreaterThan);
        continue;
      }
      if (condition.isGreaterThanOrEqualTo != null) {
        q = q.where(condition.fieldName,
            isGreaterThanOrEqualTo: condition.isGreaterThanOrEqualTo);
        continue;
      }
      if (condition.arrayContains != null) {
        q = q.where(condition.fieldName,
            arrayContains: condition.arrayContains);
        continue;
      }
      if (condition.arrayContainsAny != null) {
        q = q.where(condition.fieldName,
            arrayContainsAny: condition.arrayContainsAny);
        continue;
      }
      if (condition.whereIn != null) {
        q = q.where(condition.fieldName, arrayContainsAny: condition.whereIn);
        continue;
      }
      if (condition.whereNotIn != null) {
        q = q.where(condition.fieldName,
            arrayContainsAny: condition.whereNotIn);
        continue;
      }
      if (condition.isNull != null) {
        q = q.where(condition.fieldName, isNull: condition.isNull);
        continue;
      }
      if (condition.isNull != null) {
        q = q.where(condition.fieldName, isNull: condition.isNull);
        continue;
      }
    }
    return q;
  }
}

enum ConditionQuery {
  fieldName,
  isEqualTo,
  isNotEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  arrayContains,
  arrayContainsAny,
  whereIn,
  whereNotIn,
  isNull,
  contains;
}

class QueryCondition {
  String get fieldName => _fieldName;

  Object? get isEqualTo => _isEqualTo;

  Object? get isNotEqualTo => _isNotEqualTo;

  Object? get isLessThan => _isLessThan;

  Object? get isLessThanOrEqualTo => _isLessThanOrEqualTo;

  Object? get isGreaterThan => _isGreaterThan;

  Object? get isGreaterThanOrEqualTo => _isGreaterThanOrEqualTo;

  List<Object?>? get arrayContains => _arrayContains;

  List<Object?>? get arrayContainsAny => _arrayContainsAny;

  List<Object?>? get whereIn => _whereIn;

  List<Object?>? get whereNotIn => _whereNotIn;

  bool? get isNull => _isNull;

  String? get contains => _contains;

  final String _fieldName;
  final Object? _isEqualTo;
  final Object? _isNotEqualTo;
  final Object? _isLessThan;
  final Object? _isLessThanOrEqualTo;
  final Object? _isGreaterThan;
  final Object? _isGreaterThanOrEqualTo;
  final List<Object>? _arrayContains;
  final List<Object?>? _arrayContainsAny;
  final List<Object?>? _whereIn;
  final List<Object?>? _whereNotIn;
  final bool? _isNull;
  final String? _contains;

  QueryCondition(
      {required fieldName,
      isEqualTo,
      isNotEqualTo,
      isLessThan,
      isLessThanOrEqualTo,
      isGreaterThan,
      isGreaterThanOrEqualTo,
      arrayContains,
      arrayContainsAny,
      whereIn,
      whereNotIn,
      isNull,
      contains})
      : _fieldName = fieldName,
        _isEqualTo = isEqualTo,
        _isNotEqualTo = isNotEqualTo,
        _isLessThan = isLessThan,
        _isLessThanOrEqualTo = isLessThanOrEqualTo,
        _isGreaterThan = isGreaterThan,
        _isGreaterThanOrEqualTo = isGreaterThanOrEqualTo,
        _arrayContains = arrayContains,
        _arrayContainsAny = arrayContainsAny,
        _whereIn = whereIn,
        _whereNotIn = whereNotIn,
        _isNull = isNull,
        _contains = contains;

  @override
  String toString() {
    return 'QueryCondition{_fieldName: $_fieldName, _isEqualTo: $_isEqualTo}';
  }
}
