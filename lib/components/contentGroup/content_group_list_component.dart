import 'package:link_dance/components/contentGroup/content_group_item_list.dart';
import 'package:link_dance/components/list_view_component.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/model/content_group_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:link_dance/repository/content_group_respository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentGroupListComponent extends StatelessWidget {
  bool readOnly;
  late UserModel user;
  late ContentGroupRepository contentGroupRepository;

  ContentGroupListComponent({Key? key, this.readOnly = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AuthenticationFacate>(context, listen: false).user!;
    contentGroupRepository =
        Provider.of<ContentGroupRepository>(context, listen: false);
    return ListViewComponent<ContentGroupModel, ContentGroupRepository>(
        reload: () {
          return search();
        },
        query: refresh,
        loadDataFuture: search(),
        itemBuild: (data) => ContentGroupComponent(
              contentGroup: data,
              readOnly: readOnly,
            ));
  }

  Future<List<ContentGroupModel>?> search() async {
    if (readOnly) {
      return contentGroupRepository.getAllPagination();
    } else {
      return contentGroupRepository.getAllPagination(conditions: [
        QueryCondition(fieldName: "ownerId", isEqualTo: user.id)
      ]);
    }
  }

  Future<void> refresh() async {
    await contentGroupRepository.next();
  }
}
