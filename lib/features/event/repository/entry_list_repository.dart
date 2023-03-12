import 'package:link_dance/features/event/model/entry_list_model.dart';
import 'package:link_dance/features/event/model/guest_list_entry_model.dart';
import 'package:link_dance/repository/base_repository.dart';

import '../../../core/exception/custom_exeptions.dart';

class EntryListRepository extends BaseRepository<EntryListEventModel> {
  EntryListRepository() {
    collectionName = "entryListEvent";
  }

  Future<void> updateDynamicLink(
      {required String id, required String dynamicLink}) async {
    updateBase(data: { "dynamicLink": dynamicLink},id: id)
        .catchError((onError) {
      print("Erro ao atualizar entry list dynamic link $onError");
      throw onError;
    });
  }

  Future<List<EntryListEventModel>?> getByEventId({required String eventId}) {

    return listBase(orderDesc: true, conditions:[ QueryCondition(fieldName: "eventId",isEqualTo: eventId)], orderBy: "label");
  }

  Future<void> updateGuestEntryList({required   Map<String, dynamic> data,required String id}) async {

    updateBase(data: data,id: id).catchError((onError) {
      throw PersistenceFirebaseException(" Erro ao atualizar lista de convidados $onError" );
    });
  }
}
