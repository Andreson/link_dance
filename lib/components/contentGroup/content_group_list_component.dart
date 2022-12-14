import 'package:link_dance/components/contentGroup/content_group_item_list.dart';
import 'package:link_dance/components/list_view_component.dart';
import 'package:link_dance/model/content_group_model.dart';
import 'package:link_dance/repository/content_group_respository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentGroupListComponent extends StatelessWidget {

  bool readOnly;
  late ContentGroupRepository contentGroupRepository;
  ContentGroupListComponent({this.readOnly=true});

  @override
  Widget build(BuildContext context) {

    contentGroupRepository =
        Provider.of<ContentGroupRepository>(context, listen: false);
    return ListViewComponent<ContentGroupModel, ContentGroupRepository>(
        reload: (){
          return contentGroupRepository.getAllPagination();
        },
        query: refresh,
        loadDataFuture: contentGroupRepository.getAllPagination(),

        itemBuild: (data) => ContentGroupComponent(
              contentGroup: data,readOnly: readOnly,
            ));
  }

  Future<void> refresh() async {
    await contentGroupRepository.next();
  }
}
