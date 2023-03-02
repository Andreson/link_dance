
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/repository/user_repository.dart';

class EventEntryListHelper {

 late  UserRepository _userRepository;
 late AuthenticationFacate auth;

 EventEntryListHelper({required this.auth}): _userRepository = UserRepository(auth: auth);

 Future<UserModel?> findUserByEmail({required String email}) {
   return _userRepository.findUserByEmail(UserModel.Mock(email: email.trim()));
 }

}