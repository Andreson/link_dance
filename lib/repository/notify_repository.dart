

import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/model/notify_message_model.dart';
import 'package:link_dance/repository/base_repository.dart';

class NotifyMessageRepository extends BaseRepository<NotifyMessageModel>  {


  AuthenticationFacate? auth;

  NotifyMessageRepository({this.auth}){
    collectionName="notifyMessage";
  }

}