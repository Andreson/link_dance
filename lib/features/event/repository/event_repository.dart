import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/model/user_event_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EventRepository extends BaseRepository<EventModel> {
  AuthenticationFacate? auth;
  bool shouldUseFirestoreEmulator = false;

  EventRepository({this.auth, List<EventModel>? data}) {
    listData = data ?? [];
    collectionName="event";
  }
  Future<List<EventModel>?> likeSearch(
      {int limit = Constants.pageSize,
        bool nextPage = false,
        required QueryCondition condition,
        required String orderBy}) async {
    return likeSearchBase(condition: condition, orderBy: orderBy,nextPage: nextPage,limit: limit);
  }

  @override
  Future<List<EventModel>?> listBase(
      {int limit = Constants.pageSize,
        bool nextPage = false,
        List<QueryCondition>? conditions,
        bool orderDesc = true,
        bool notifyListen = true,
        String orderBy = "eventDate"}) async {

    return super.listBase(orderBy: orderBy,orderDesc: orderDesc,notifyListen: notifyListen,nextPage: nextPage,conditions: conditions);
  }

  Future<UserEventModel?> subscribeEvent(
      {required EventModel event, UserModel? user}) async {
    var userTemp = user ?? auth!.user!;
    UserEventModel? tempUserEvent;
    tempUserEvent = await getSubscriptionEvent(eventId: event.id);
    if (tempUserEvent != null) {
      //atualiza o registro no evento caso ele ja exista
      _updateStatusEvent(
          userEvent: tempUserEvent, status: EventRegisterStatus.subscribe);
      tempUserEvent.status = EventRegisterStatus.subscribe;
      return tempUserEvent;
    }

    var ue = UserEventModel(
        userId: userTemp.id,
        eventId: event.id,
        userEmail: userTemp.email,
        userPhone: userTemp.phone!,
        status: EventRegisterStatus.subscribe,
        createDate: Timestamp.now());
    var response = await (await FirebaseFirestore.instance
            .collection('usersEventRegistered')
            .withConverter<UserEventModel>(
              fromFirestore: (snapshot, _) =>
                  UserEventModel.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (userEvent, _) => userEvent.body(),
            )
            .add(ue))
        .get();
    var newUserEventModel = response.data();
    print("newUserEventModel cadastrado?   ${newUserEventModel}");

    return newUserEventModel;
  }

  Future<UserEventModel?> getSubscriptionEvent(
      {String? userId, required String eventId}) async {
    var userIdTemp = userId ?? auth!.user!.id;

    print("event quer parameters :   $userIdTemp and $eventId");

    var response = await FirebaseFirestore.instance
        .collection('usersEventRegistered')
        .where("userId", isEqualTo: userIdTemp)
        .where("eventId", isEqualTo: eventId)
        .withConverter<UserEventModel>(
          fromFirestore: (snapshot, _) =>
              UserEventModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (userEvent, _) => userEvent.body(),
        )
        .get();

    if (response.docs.isNotEmpty) {
      return response.docs.first.data();
    } else {
      return null;
    }
  }

  Future<void> _updateStatusEvent(
      {required UserEventModel userEvent,
      required EventRegisterStatus status}) {
    var user = auth!.user!;
    return FirebaseFirestore.instance
        .collection('usersEventRegistered')
        .doc(userEvent.id)
        .update({
      "status": status.name,
      "userEmail": user.email,
      "userPhone": user.phone
    }).catchError((onError) => throw onError);
  }

  Future<void> unsubscribeEvent({required UserEventModel userEvent}) {
    return _updateStatusEvent(
        userEvent: userEvent, status: EventRegisterStatus.unsubscribe);
  }

  Future<List<EventModel>?> findByUserIdPagination(
      {required String userId, int limit = 10, bool nextPage = false}) async {
    var response = _queryRef();
    if (nextPage) {
      response.startAfterDocument(paginationPointer);
    }

    var eventDocs  =await response.limit(limit)
        .orderBy("createDate", descending: true)
        .queryBy(EventQuery.userId, [userId]).get();

    if ( eventDocs.docs.isNotEmpty) {
      paginationPointer = await eventDocs.docs.last.reference.get();
      listData.addAll( (eventDocs.docs.map((item) => item.data()).toList()) ) ;
      print("listData size ${listData.length}");

    }
    notifyListeners();
    return listData;
  }

  Stream<QuerySnapshot<EventModel>> findByUserId(String userId) {
    var response = _queryRef()
        .orderBy("createDate", descending: false)
        .queryBy(EventQuery.userId, [userId]).snapshots();

    return response;
  }

  Future<void> delete(EventModel event) async {
    var collection = FirebaseFirestore.instance.collection("event");
    await collection.doc(event.id).delete().catchError((onError) {
      throw onError;
    });
    event.storageRef?.forEach((path) async {
      await FirebaseStorage.instance.ref().child(path).delete();
    });
  }

  Query<EventModel> _queryRef() {
    return _getCollection().withConverter<EventModel>(
        fromFirestore: (snapshots, _) {
          var data = snapshots.data()!;
          data['id'] = snapshots.id;
          return EventModel.fromJson(data);
        },
        toFirestore: (event, _) => event.body());
  }

  Future<void> saveOrUpdate(EventModel event) async {
    if (event.id.isEmpty) {
      print("Criando novo  evento ${event.title}");
      return _save(event);
    } else {
      print("Atualizando evento ${event.title}");
      return _update(event);
    }
  }

  Future<void> _save(EventModel event) async {
    var response =
        await _getCollection().add(event.body()).catchError((onError) {
      print("Erro nao esperado ao gravar evento $onError");
      throw onError;
    });
  }

  Future<void> _update(EventModel event) async {
    return _getCollection()
        .doc(event.id)
        .update(event.deserialize())
        .catchError((error) => throw error);
  }

  CollectionReference _getCollection() {
    return FirebaseFirestore.instance.collection('event');
  }

  factory EventRepository.New() {
    return EventRepository(auth: AuthenticationFacate(), data: []);
  }
}

enum EventQuery { eventDate, dateAsc, dateDesc, title, tags, fantasy, userId }

extension on Query<EventModel> {
  /// Create a firebase query from a [EventQuery]
  Query<EventModel> queryBy<T>(EventQuery query, List<T> valuesParam) {
    switch (query) {
      case EventQuery.eventDate:
        return where('eventDate', isEqualTo: valuesParam.first);

      case EventQuery.dateAsc:
      case EventQuery.dateDesc:
        return orderBy('eventDate', descending: query == EventQuery.dateDesc);

      case EventQuery.userId:
        return where('userId', isEqualTo: valuesParam.first);

      case EventQuery.tags:
        return where('tags', whereIn: valuesParam);
      default:
        return orderBy('eventDate', descending: query == EventQuery.dateDesc);
    }
  }
}
