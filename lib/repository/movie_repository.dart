import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';

import 'package:link_dance/model/movie_model.dart';
import 'package:link_dance/repository/base_repository.dart';

class MovieRepository extends BaseRepository<MovieModel> {
  AuthenticationFacate? auth;

  MovieRepository({this.auth, List<MovieModel>? data}) {
    listData = data ?? [];
    restTemplate = RestTemplate(auth: auth!);
    collectionName = "movie";
  }

  Future<void> loadData() async {
    clear();
    await restTemplate.Get(url: "${Constants.moviesDbUrl}.json?")
        .then((response) {
      response.forEach((key, data) {
        add(MovieModel.fromJson(data, key));
      });
      // notifyListeners();
    });
  }
  @override
  Future<List<MovieModel>?> nextPageBase({int? nextRegistry}) {

    return super.nextPageBase();
  }
  Future<void> findByContentGroup(String contentGroupId) async {
    clear();

    listBase(conditions: [
      QueryCondition(fieldName: "contentGroupId", isEqualTo: contentGroupId)
    ]);
  }

  Future<List<MovieModel>?> list() {

    return listBase(orderBy: "createDate",orderDesc: true);
  }

  Future<List<MovieModel>?> getAllPagination(
      {int limit = 10, bool nextPage = false}) async {
    var response = await FirebaseFirestore.instance
        .collection('movie')
        .where("public", isEqualTo: true)
        .orderBy("createDate", descending: true)
        .withConverter<MovieModel>(
            fromFirestore: (snapshots, _) {
              return MovieModel.fromJson(snapshots.data()!, snapshots.id);
            },
            toFirestore: (event, _) => event.body())
        .limit(limit)
        .get();

    if (response.docs.isNotEmpty) {
      paginationPointer = await response.docs.last.reference.get();
      listData = (response.docs.map((item) => item.data()).toList());

      //notifyListeners();
    }
    return listData;
  }

  Future<List<MovieModel>?> findByOwnerIdPagination(
      {required String ownerID, int limit = 10, bool nextPage = false}) async {
    var response = await FirebaseFirestore.instance
        .collection('movie')
        .withConverter<MovieModel>(
            fromFirestore: (snapshots, _) {
              return MovieModel.fromJson(snapshots.data()!, snapshots.id);
            },
            toFirestore: (event, _) => event.body())
        .where("ownerId", isEqualTo: ownerID)
        .orderBy("createDate", descending: false)
        .limit(limit)
        .get();
    print("========================================= ownerID:  $ownerID");

    if (response.docs.isNotEmpty) {
      paginationPointer = await response.docs.last.reference.get();
      listData = (response.docs.map((item) => item.data()).toList());
      print("-------------------- lista de videos carregados $listData");
      notifyListeners();
    }
    return listData;
  }

  Future<dynamic> create(MovieModel movie) async {
    await saveOrUpdateBase(data: movie.deserialize());
  }

  Future<List<String>> findRhythms() async {
    return [
      "Sertanejo",
      "Vaneira paulista",
      "Forró",
      "Salsa",
      "Ballet",
      "Dança livre",
      "Man Styles",
      "Lady Styles",
      "Zouk",
      "Samba Rock",
      "Samba de Gafiera",
      "Rock",
      "Soltinho",
      "Bachata",
      "West Coast",
      "Bolero",
      "Valsa",
      "Merengue",
      "Tango",
      "Lindy Hop",
      "Mambo",
      "Dança do ventre",
      "Cha chá chá",
      "Varios ritmos"
    ];
  }

  factory MovieRepository.New() {
    return MovieRepository(data: []);
  }

  CollectionReference<MovieModel> _getMovieCollection() {
    return FirebaseFirestore.instance
        .collection('movie')
        .withConverter<MovieModel>(
            fromFirestore: (snapshots, _) {
              return MovieModel.fromJson(snapshots.data()!, snapshots.id);
            },
            toFirestore: (event, _) => event.body());
  }
}

enum MovieQuery { ownerId, dateAsc, dateDesc, contentGroupId, rhythm }

extension on Query<MovieModel> {
  Query<MovieModel> queryBy<T>(MovieQuery query, List<T> valuesParam) {
    switch (query) {
      case MovieQuery.ownerId:
        return where('ownerId', isEqualTo: valuesParam.first);
      case MovieQuery.contentGroupId:
        return where('contentGroupId', isEqualTo: valuesParam.first);
      case MovieQuery.rhythm:
        return where('rhythm', isEqualTo: valuesParam.first);

      case MovieQuery.dateAsc:
        return orderBy('createDate', descending: query == MovieQuery.dateAsc);
      case MovieQuery.dateDesc:
        return orderBy('createDate', descending: query == MovieQuery.dateDesc);

      default:
        return orderBy('createDate', descending: query == MovieQuery.dateDesc);
    }
  }
}
