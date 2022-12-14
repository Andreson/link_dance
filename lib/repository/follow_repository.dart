import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/model/follow_count_model.dart';
import 'package:link_dance/model/user_follow_teacher_model.dart';
import 'package:link_dance/repository/base_repository.dart';

class FollowRepository extends BaseRepository<UserFollowTeacherModel> {
  AuthenticationFacate? auth;
  FollowCountModel? followCount;
  UserFollowTeacherModel? followVo;
  FollowRepository({this.auth});

  Future<UserFollowTeacherModel> followOrUnfollow(
      {required UserFollowTeacherModel followVo}) async {
    if (followVo.status == FollowStatusStatus.follow) {
      if (followVo.id == null) {
        await _registerFollow(followVo);
        followVo = (await getFollow(teacherId: followVo.teacherId))!;
      } else {
        await _updateFollow(follow: followVo);
      }
    } else {
      await _updateFollow(follow: followVo);
    }
    this.followVo =followVo;
    notifyListeners();
    return followVo;
  }

  Future<void> _registerFollow(UserFollowTeacherModel followVo) async {
    await _getUserFollowCollection().add(followVo.body()).catchError((onError) {
      print("Erro nao esperado ao gravar follow user $onError");
      throw onError;
    });
  }

  Future<FollowCountModel> getOrCreate({required String teacherID}) async {
    var response = await _getFollowCollection()
        .where("ownerId", isEqualTo: teacherID)
        .get();

    if (response.docs.isEmpty) {
      followCount=  (await (await _getFollowCollection()
                  .add(FollowCountModel(id: "", ownerId: teacherID, like: 1)))
              .get())
          .data()!;
    } else {
      followCount=  response.docs.first.data();
    }
    notifyListeners();
    return followCount!;
  }

  incrementFollow({required FollowCountModel followCount}) async {
    await _getFollowCollection()
        .doc(followCount.id)
        .update({"like": FieldValue.increment(1)});
    this.followCount?.like++;
    notifyListeners();
  }

  decrementFollow({required FollowCountModel followCount}) async {
   var res = ( await _getFollowCollection()
        .doc(followCount.id)
        .update({"like": FieldValue.increment(-1)}) );
   this.followCount?.like--;
   notifyListeners();
  }

  Future<UserFollowTeacherModel?> getFollow({required String teacherId}) async {
    var userIdTemp = auth!.user!.id;

    var response = await _getUserFollowCollection()
        .where("userId", isEqualTo: userIdTemp)
        .where("teacherId", isEqualTo: teacherId)
        .withConverter<UserFollowTeacherModel>(
          fromFirestore: (snapshot, _) =>
              UserFollowTeacherModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (userEvent, _) => userEvent.body(),
        )
        .get();
    if (response.docs.isNotEmpty) {
      return response.docs.first.data();
    } else {
      return null;
    }
  }

  Future<void> _updateFollow({required UserFollowTeacherModel follow}) async {
    var user = auth!.user!;
    return _getUserFollowCollection().doc(follow.id).update({
      "status": follow.status.name,
      "userEmail": user.email,
      "userPhone": user.phone
    }).catchError((onError) => throw onError);
  }

  CollectionReference _getUserFollowCollection() {
    return FirebaseFirestore.instance.collection('userFollowTeacher');
  }

  CollectionReference<FollowCountModel> _getFollowCollection() {
    return FirebaseFirestore.instance
        .collection('followerCount')
        .withConverter<FollowCountModel>(
            toFirestore: (followCount, _) => followCount.body(),
            fromFirestore: (snapshot, _) =>
                FollowCountModel.fromJson(snapshot.data()!, snapshot.id));
  }
}
