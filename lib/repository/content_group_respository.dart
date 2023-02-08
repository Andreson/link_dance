import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/helpers/constantes_config.dart';
import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/model/content_group_model.dart';
import 'package:link_dance/model/content_user_acess_model.dart';
import 'package:link_dance/repository/base_repository.dart';

class ContentGroupRepository extends BaseRepository<ContentGroupModel> {
  ContentGroupRepository({this.auth}){
    collectionName="contentGroup";
  }
  AuthenticationFacate? auth;

  Future<List<ContentGroupModel>?> getAllPagination(
       { int limit = ConstantsConfig.pageSize, bool nextPage = false,List<QueryCondition>? conditions})  async{
    print("Realizando query :  $conditions");

    return listBase( limit: limit,conditions:  conditions,orderDesc: true,orderBy: "startClassDate");
  }
  Future<List<ContentGroupModel>?> like( {int limit = ConstantsConfig.pageSize,
    bool nextPage = false,
    required QueryCondition condition,
    required String orderBy})  async{
     await likeSearchBase(condition: condition, orderBy: orderBy);
     for (var element in listData) {
       print("title content group return ${element.title}");
     }
     print("Total de registros no Rsultado das buscas ${listData.length}");
  }


  Future<List<ContentGroupModel>?> next(
      { int? limit})  async{
   return nextPageBase(nextRegistry:limit);
  }


  Future<List<ContentGroupModel>> findByUserIdRhythm(
      {required String ownerId, String? rhythm}) async {
    var query = _queryRef()
        .orderBy("createDate", descending: false)
        .where("ownerId", isEqualTo: ownerId);
    if (rhythm != null) {
      query = query.where("rhythm", isEqualTo: rhythm);
    }
    var response = await query.get();
    return response.docs.map((e) => e.data()).toList();
  }


  Future<ContentUserAcessModel?> getAcessUser(
      {required String userId, required String contentGroupId}) async {
    var query = _queryRefContentUser()
        .where("userId", isEqualTo: userId).where("contentGroupId", isEqualTo: contentGroupId);

    var response = await query.get();
    if (response.docs.isNotEmpty) {
      return response.docs.map((e) => e.data()).first;
    } else {
      return null;
    }
  }


  Future<void> saveOrUpdate(ContentGroupModel teamClass) async {
    if (teamClass.id.isEmpty) {
      return _save(teamClass);
    } else {
      return _update(teamClass);
    }
  }

  Future<void> _update(ContentGroupModel teamClass) async {
    return _getCollection()
        .doc(teamClass.id)
        .update(teamClass.body())
        .catchError((error) => throw error);
  }

  Future<void> _save(ContentGroupModel event) async {
    var response =
    await _getCollection().add(event.body()).catchError((onError) {
      print("Erro nao esperado ao gravar evento $onError");
      throw onError;
    });
  }

  CollectionReference _getCollection() {
    return FirebaseFirestore.instance.collection('contentGroup');
  }

  Query<ContentGroupModel> _queryRef({int limit = 10}) {
    return _getCollection().limit(limit).withConverter<ContentGroupModel>(
        fromFirestore: (snapshots, _) {
          return ContentGroupModel.fromJson(snapshots.data()!, snapshots.id);
        },
        toFirestore: (event, _) => event.body());
  }

  Query<ContentUserAcessModel> _queryRefContentUser({int limit = 10}) {
    return _getCollectionAcess().limit(limit).withConverter<ContentUserAcessModel>(
        fromFirestore: (snapshots, _) {
          return ContentUserAcessModel.fromJson(snapshots.data()!, snapshots.id);
        },
        toFirestore: (contentAcess, _) => contentAcess.body());
  }

  CollectionReference _getCollectionAcess() {
    return FirebaseFirestore.instance.collection('contentUserAccess');
  }
}
