import 'package:flutter/material.dart';

class ScreenDetailVo {}

class PageHeaderDetailVo {
  String? title;
  List<Widget>? subTitle;
  String imageBackground;
  double? width;
  double? height;

  PageHeaderDetailVo(
      {this.title,
      this.subTitle,
      required this.imageBackground,
      this.width,
      this.height});
}

class PageDetailBodyVo {
  String title;
  List<Widget>? subTitle;
  String description;
  List<Widget>? info;

  PageDetailBodyVo(
      {required this.title,
      this.subTitle,
      required this.description,
      this.info});
}

class ScreenFooterVo {}
