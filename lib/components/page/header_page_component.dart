import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/features/cache/movie_cache_helper.dart';
import 'package:link_dance/model/vo/detail_screen_vo.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:link_dance/core/theme/fontStyles.dart';

class PageHeaderComponent extends StatelessWidget {
  late PageHeaderDetailVo headerData;

  PageHeaderComponent({required this.headerData});

  CachedManagerHelper cachedManager = CachedManagerHelper();
  late ImageProvider imageProviderCache;

  @override
  StatelessElement createElement() {
    return super.createElement();
  }

  Widget getImage({required double width, required double height}) {
    return cachedManager.getImage(
        url: headerData.imageBackground,
        width: width,
        height: height / 2.8,
        fit: BoxFit.fitHeight,
        onCache: (ImageProvider img) {
          print("----------------------- inciando imageProviderCache ");
          imageProviderCache = img;
        });
  }

  @override
  Widget build(BuildContext context) {
    var width = headerData.width ?? MediaQuery.of(context).size.width;
    var height = headerData.height ?? MediaQuery.of(context).size.height;

    return Stack(alignment: Alignment.bottomRight, children: [
      GestureDetector(
        onTap: () {
          showImageViewer(context, imageProviderCache, onViewerDismissed: () {
            print("dismissed");
          });
        },
        child: getImage(width: width, height: height),
      ),
      Container(
        width: width,
        decoration: boxRadiusCustom(opacity: 0.6, radiusBottom: 0),
        child: titleAndSubtitle(),
        //margin: const EdgeInsets.only(top: 240),
      ),
    ]);
  }

  Widget titleAndSubtitle() {
    return Column(
      children: [
        if (headerData.title != null)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 15, bottom: 0),
              child: SelectableText(
                headerData.title!,
                style: boxTitleStyle(),
              ),
            ),
          ),
        if (headerData.subTitle != null)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 15, bottom: 5),
              child: Wrap(children: headerData.subTitle!),
            ),
          ),
      ],
    );
  }
}
