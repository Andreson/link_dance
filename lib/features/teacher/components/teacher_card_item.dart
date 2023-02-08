import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/helpers/movie_cache_helper.dart';

import 'package:link_dance/model/teacher_model.dart';
import 'package:flutter/material.dart';

import 'package:link_dance/core/theme/fontStyles.dart';
import 'package:link_dance/core/theme/theme_data.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';


class TeacherCardItemList extends StatelessWidget {
  const TeacherCardItemList({
    required this.teacher,
    Key? key,
  }) : super(key: key);

  final TeacherModel teacher;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed(context, RoutesPages.teacherPage.name,
            arguments: teacher)
      },
      child: Stack(
        children: [
          Padding(
            padding:const EdgeInsets.fromLTRB(15, 10, 15, 15),
            child: Center(
              child: Container(
                decoration: box(opacity: 0.3, allBorderRadius: 0),
                width: 300,
                height: 300,
              ),
            ),
          ),
          Center(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                  width: 275,
                  height: 240,
                  child: ProductImage(teacherModel: teacher))),
          Center(
            child: Container(
              width: 246,
              decoration: boxRadiusCustom(opacity: 0.3, radiusBottom: 15),
              margin: const EdgeInsets.fromLTRB(0, 187, 0, 0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 00, 0, 5),
                child: Text(
                  teacher.name,
                  style: boxTitleStyle(),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(0, 230, 0, 0),
            child: const Text(
              "Ritmos",
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 250, 0, 0),
              width: 240,
              child: Wrap(
                children: [buildTags(teacher.danceRhythms)],
              ),
            ),
          )
        ],
      ),
    );
  }



  Widget buildTags(List<String> tagsData) {
    const double edges = 5;
    return ChipsChoice<int>.single(
      choiceStyle: const C2ChoiceStyle(
        elevation: 0,
        color: Colors.black,
        showCheckmark: true,
        labelStyle: TextStyle(fontSize: 10),
        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
        //borderColor: Colors.blueGrey.withOpacity(0.2),
      ),
      onChanged: (val) {},
      value: tagsData.length,
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      choiceItems: C2Choice.listFrom<int, String>(
        source: tagsData,
        value: (i, v) => i,
        label: (i, v) => v,
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
    ProductImage({
    Key? key,
    required this.teacherModel,
  }) : super(key: key);
    CachedManagerHelper cachedManager = CachedManagerHelper();

  final TeacherModel teacherModel;

  @override
  Widget build(BuildContext context) {
    Widget imagem;
    if(teacherModel.photo!=null) {
      imagem = cachedManager.getImage(
        url: teacherModel.photo!,
      );
    }else {
      imagem =  teacherModel.photoAvatar;
    }
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: Opacity(
        opacity: 0.85,
        child: imagem,
      ),
    );
  }
}

class LikeCount extends StatelessWidget {
  const LikeCount({
    required this.count,
    required this.isLike,
    Key? key,
  }) : super(key: key);

  final int count;
  final bool isLike;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isLike ? Icons.thumb_up : Icons.thumb_down,
          color: isLike ? kGreenColor : kRedColor,
          size: 15,
        ),
        SizedBox(width: 3),
        Text(
          count.toString(),
          style: kInfoText,
        )
      ],
    );
  }
}

class Ratings extends StatelessWidget {
  const Ratings({
    this.rating,
    Key? key,
  }) : super(key: key);

  final double? rating;

  @override
  Widget build(BuildContext context) {
    Color _color = rating != null ? kGreenColor : Colors.grey;
    Icon _icon = Icon(rating != null ? Icons.star : Icons.star_outline,
        color: _color, size: 15);
    Icon _iconhalf = Icon(rating != null ? Icons.star : Icons.star_outline,
        color: _color, size: 15);
    return Row(
      children: [
        _icon,
        _icon,
        _icon,
        _icon,
        _iconhalf,
        SizedBox(width: 4),
        Text(
          rating != null ? rating.toString() : "NA",
          style: kInfoText,
        ),
      ],
    );
  }
}
