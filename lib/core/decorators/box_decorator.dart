import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Decoration boxLinearGradiente(List<Color> colors,
    {double allCircularBorderRadius = 0}) {
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
      borderRadius: BorderRadius.all(Radius.circular(allCircularBorderRadius)));
}

Decoration box(
    {Color color = Colors.black,
    double opacity = 0,
    double allBorderRadius = 0}) {
  return BoxDecoration(
    color: opacity == 0 ? color : color.withOpacity(opacity),
    borderRadius: BorderRadius.all(Radius.circular(allBorderRadius)),
  );
}

Decoration boxRadiusCustom(
    {Color color = Colors.black,
    double opacity = 0,
    double radiusTop = 2,
      double radiusBottom = 2}) {
  return BoxDecoration(
      color: opacity == 0 ? color : color.withOpacity(opacity),
      borderRadius: new BorderRadius.only(
        bottomLeft:  Radius.circular(radiusBottom),
        bottomRight: Radius.circular(radiusBottom),
        topLeft:  Radius.circular(radiusTop),
        topRight: Radius.circular(radiusTop),
      ));
}

Decoration boxImage(String imagemURL,
    {double allCircularBorderRadius = 0, double opacity = 0.5}) {
  return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imagemURL),
        fit: BoxFit.cover,
        colorFilter:  ColorFilter.mode(
            Colors.black.withOpacity(opacity), BlendMode.dstATop),
      ),
      borderRadius: BorderRadius.all(Radius.circular(allCircularBorderRadius)));
}

Decoration boxImageNetWork(String imagemURL,
    {double allCircularBorderRadius = 0, double opacity = 0.5}) {
  return BoxDecoration(
      image: DecorationImage(
        image: Image.network(imagemURL).image,
        fit: BoxFit.cover,
        colorFilter: new ColorFilter.mode(
            Colors.black.withOpacity(opacity), BlendMode.dstATop),
      ),
      borderRadius: BorderRadius.all(Radius.circular(allCircularBorderRadius)));
}

SizedBox sizedBox200300([Widget? chield]) {
  return SizedBox(
    height: 200,
    width: 300,
    child: chield,
  );
}

SizedBox sizedBox50() {
  return const SizedBox(
    height: 50,
  );
}

SizedBox sizedBox75() {
  return const SizedBox(
    height: 50,
  );
}

SizedBox sizedBox30() {
  return const SizedBox(
    height: 30,
  );
}

SizedBox sizedBox10() {
  return const SizedBox(
    height: 10,
  );
}

SizedBox sizedBox15() {
  return const SizedBox(
    height: 15,
  );
}
SizedBox sizedBox20() {
  return const SizedBox(
    height: 20,
  );
}

SizedBox sizedBoxH15() {
  return const SizedBox(
    width: 15,
  );
}

SizedBox sizedBoxH10() {
  return const SizedBox(
    width: 10,
  );
}
SizedBox sizedBoxH5() {
  return const SizedBox(
    width: 5,
  );
}
SizedBox sizedBoxH20() {
  return const SizedBox(
    width: 20,
  );
}


