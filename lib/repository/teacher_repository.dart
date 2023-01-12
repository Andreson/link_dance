import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/model/teacher_model.dart';
import 'package:link_dance/repository/base_repository.dart';

class TeacherRepository extends BaseRepository<TeacherModel> {
  AuthenticationFacate? auth;

  TeacherRepository({this.auth, List<TeacherModel>? data}) {
    listData = data ?? [];
    restTemplate = RestTemplate(auth: auth!);
    collectionName = "teacher";
  }



  @override
  Future<List<TeacherModel>?> listBase(
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


  Future<List<TeacherModel>?> _executeGenericQuery(
      {int limit = Constants.pageSize,
        bool nextPage = false,
        List<QueryCondition>? conditions,
        String orderBy = "createDate",
        required Query<TeacherModel> query}) async {
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



  CollectionReference<TeacherModel> _queryRef({required String collectionName}) {
    return getCollectionBase(collectionName: collectionName).withConverter<TeacherModel>(
        fromFirestore: (snapshots, _) {
          return TeacherModel.fromJson(snapshots.data()!, snapshots.id);
        },
        toFirestore: (model, _) => model.body());
  }


  @deprecated
  Future<List<TeacherModel>> loadData() async {
    clear();
    List<TeacherModel>? resp = (await listBase(
        notifyListen: false,
        orderBy: "name",
        conditions: [QueryCondition(fieldName: "status", isEqualTo: AccountStatus.enable.name())]));
    listData = resp ?? [];
    notifyListeners();
    return listData;
  }

  Future<TeacherModel?> findByUserId({required String userId}) async {
    var responseList = (await listBase(
        orderBy: "name",
        conditions: [QueryCondition(fieldName: "userId", isEqualTo: userId)]));

    if (responseList != null && responseList.isNotEmpty) {
      return responseList.first;
    }
    return null;
  }

  Future<Map<String, dynamic>> saveOrUpdate(TeacherModel teacher) async {
    saveOrUpdateBase(data: teacher.body());
    return teacher.body();
  }

  factory TeacherRepository.New() {
    return TeacherRepository(auth: AuthenticationFacate(), data: []);
  }
}
