import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/components/widgets/image_card.dart';
import 'package:link_dance/core/dynamic_links/dynamic_links_helper.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/helpers/util_helper.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:link_dance/core/theme/fontStyles.dart';
import 'package:link_dance/core/theme/theme_data.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';

class EventCardItemList extends StatelessWidget {
  const EventCardItemList({
    required this.event,
    Key? key,
  }) : super(key: key);

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    var eventRepository = Provider.of<EventRepository>(context, listen: false);

    return GestureDetector(
      onTap: () => {
      Navigator.pushNamed(context, RoutesPages.eventDetail.name, arguments: {"event": event})
    },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
            child: Center(
              child: Container(
                decoration: box(opacity: 0.3, allBorderRadius: 0),
                width: 300,
                height: 270,
              ),
            ),
          ),

          Center(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                  width: 275,
                  height: 240,
                  child: ImagemCardComponent(
                    imagemURL: event.uriBannerThumb,
                  ))),
          Container(
            width: 246,
            decoration: boxRadiusCustom(opacity: 0.3, radiusBottom: 15),
            margin: const EdgeInsets.fromLTRB(74, 187, 0, 0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 00, 0, 5),
              child: Text(
                event.title,
                style: boxTitleStyle(),
              ),
            ),
          ),
          Center(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 235, 0, 0),
              width: 250,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(event.eventDate.showString()),
                    const Text(" - "),
                    Text(event.place!.capitalizePhrase()),
                    if (event.hasList())
                      Text(" - ${event.listData!.listType.label}"),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconButton getButtonShare(BuildContext context) {
    var options = DynamicLinkOptions(
      router: RoutesPages.eventDetail,
      params: {"eventId": event.id},
      imageUrl: event.uriBannerThumb!,
      title: event.shareLabel(link: ""),
    );
    return IconButton(
        onPressed: () {
          shareContent(context: context, options: options);
        },
        icon: const Icon(
          Icons.share,

        ));
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
