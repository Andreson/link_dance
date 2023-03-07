

import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/features/event/components/event_card_item.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:link_dance/features/teacher/components/teacher_card_item.dart';
import 'package:link_dance/model/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:link_dance/repository/teacher_repository.dart';
import 'package:provider/provider.dart';
import '../../../core/decorators/box_decorator.dart';
import '../../../core/factory_widget.dart';
import '../repository/event_repository.dart';

class EventListCardComponent extends StatelessWidget {

  late EventRepository repository;

  var condition = QueryCondition(fieldName: "eventDate",isGreaterThan: DateTime.now().subtract(const Duration(days: 1) ));
  @override
  Widget build(BuildContext context) {

    repository = Provider.of<EventRepository>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      await repository.listBase(conditions: [condition] );
    });

    return Container(
      decoration: boxImage("assets/images/backgroud1.jpg"),
      child: Consumer<EventRepository>(
        builder: (context, repository, child) => Scrollbar(
          child: futureBuilderList<EventRepository>(
            refreshData: refresh,
              context: context,
              initialData: repository.listData,
              itemBuild: (data) =>
                  EventCardItemList(event: (data as EventModel))),
        ),
      ),
    );
  }

  Future<void> refresh() async {
    repository.listBase(conditions: [condition]);
  }
}
