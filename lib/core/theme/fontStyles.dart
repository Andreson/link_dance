import 'package:flutter/material.dart';
import './theme_data.dart';

import 'package:flutter/material.dart';

const TextStyle kHeadingText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: kRedColor,
);

const TextStyle kTitleText = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const TextStyle kInfoText = TextStyle(
  fontSize: 13,
  color: Colors.white,
);
const TextStyle kErrorText = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: Colors.red,
);

const TextStyle formInputsStyles = TextStyle(
  fontSize: 14,
  color: inputField,

);

TextStyle formInputsStylesRead = const TextStyle(
  fontSize: 14,
  color: Colors.white30,
);

ButtonStyle buttonNoPadding = TextButton.styleFrom(
    padding: EdgeInsets.zero,
    minimumSize: Size(50, 30),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    alignment: Alignment.centerLeft);

TextStyle boxTitleStyle() {
  return const TextStyle(fontSize: 22, shadows: [
    Shadow(offset: Offset(2.0, 1), blurRadius: 1.0, color: Colors.black),
  ]);
}

Shadow shadowText() {
  return const Shadow(
      offset: Offset(1.0, 2), blurRadius: 3, color: Colors.black87);
}
