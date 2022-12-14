 
import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/rest/rest_template.dart';

import 'package:link_dance/features/authentication/auth_facate.dart';


import 'package:link_dance/model/teacher_model.dart';

import 'package:link_dance/repository/base_repository.dart';

class TeacherRepository extends BaseRepository<TeacherModel> {
  AuthenticationFacate? auth;

  TeacherRepository({this.auth, List<TeacherModel>? data}) {
    listData = data ?? [];
    restTemplate =RestTemplate(auth: auth!);
    collectionName="teacher";
  }

  @deprecated
  Future<List<TeacherModel>> loadData() async {
    clear();
     List<TeacherModel>? resp = (await listBase(notifyListen: false,orderBy: "name"));
     listData = resp?? [];
     notifyListeners();
    return listData;
  }



  Future<TeacherModel?> findByUserId({required String userId}) async {

     var responseList= (await listBase(orderBy: "name", conditions: [QueryCondition(fieldName: "userId",isEqualTo: userId )]));

     if ( responseList!=null && responseList.isNotEmpty) {
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
