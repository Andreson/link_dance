import 'package:link_dance/core/helpers/constantes_config.dart';
import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/model/notify_message_model.dart';
import 'package:link_dance/repository/base_repository.dart';

class NotifyMessageRepository extends BaseRepository<NotifyMessageModel> {
  AuthenticationFacate? auth;

  NotifyMessageRepository({this.auth}) {
    collectionName = "notifyMessage";
  }

  @override
  Future<List<NotifyMessageModel>?> listBase(
      {int limit = ConstantsConfig.pageSize,
      bool nextPage = false,
      List<QueryCondition>? conditions,
      bool orderDesc = true,
      bool notifyListen = true,
      String orderBy = "createDate"}) async {


    return super.listBase(conditions: conditions,limit: ConstantsConfig.pageSize, nextPage: false,notifyListen: notifyListen,orderDesc: orderDesc,orderBy: orderBy);
  }
}
