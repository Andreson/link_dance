import 'package:link_dance/features/event/model/entry_list_model.dart';
import 'package:link_dance/repository/base_repository.dart';

class EntryListRepository extends BaseRepository<EntryListEventModel> {
  EntryListRepository() {
    collectionName = "entryListEvent";
  }

  Future<void> updateDynamicLink(
      {required String id, required String dynamicLink}) async {
    updateBase(data: {"id": id, "dynamicLink": dynamicLink})
        .catchError((onError) {
      print("Erro ao atualizar entry list dynamic link $onError");
      throw onError;
    });
  }
}
