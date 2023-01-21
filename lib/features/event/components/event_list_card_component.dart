

import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/features/teacher/components/teacher_card_item.dart';
import 'package:link_dance/model/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:link_dance/repository/teacher_repository.dart';
import 'package:provider/provider.dart';
import '../../../core/decorators/box_decorator.dart';
import '../../../core/factory_widget.dart';

class TeacherListComponent extends StatelessWidget {
  late TeacherRepository repository;
  @override
  Widget build(BuildContext context) {
    repository = Provider.of<TeacherRepository>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      await repository.loadData();
    });

    return Container(
      decoration: boxImage("assets/images/backgroud1.jpg"),
      child: Consumer<TeacherRepository>(
        builder: (context, teacherRepository, child) => Scrollbar(
          child: futureBuilderList<TeacherRepository>(
            refreshData: refresh,
              context: context,
              initialData: repository.listData,
              itemBuild: (data) =>
                  TeacherCardItemList(teacher: (data as TeacherModel))),
        ),
      ),
    );
  }

  Future<void> refresh() async {
    repository.loadData();
  }
}
