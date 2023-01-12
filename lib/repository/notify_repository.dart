import 'package:link_dance/core/constants.dart';
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
      {int limit = Constants.pageSize,
      bool nextPage = false,
      List<QueryCondition>? conditions,
      bool orderDesc = true,
      bool notifyListen = true,
      String orderBy = "createDate"}) async {


    return super.listBase(conditions: conditions,limit: Constants.pageSize, nextPage: false,notifyListen: notifyListen,orderDesc: orderDesc,orderBy: orderBy);
  }
}
