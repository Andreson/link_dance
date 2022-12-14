import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/decorators/box_decorator.dart';

class CustomTextButton extends StatelessWidget {
   VoidCallback? onPressed;
  final String label;
  CustomTextButtonParams? params;
  Icon? icon;
  bool isSelected;
  EdgeInsets? padding;

  CustomTextButton(
      {this.onPressed,
      required this.label,
      this.params,
      this.padding,
      this.icon,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    params = params ?? CustomTextButtonParams();
    var button = Container(
      height: params!.height,
      width: params!.width,
      decoration: boxLinearGradiente(_backgroudColor(),
          allCircularBorderRadius: params!.allCircularBorderRadius),
      child: _buildButton(icon: icon),
    );
    if (padding != null) {
      return _wrapperPadding(button);
    }
    return button;
  }

  Widget _wrapperPadding(Widget child) {
    return Padding(
      padding: padding!,
      child: child,
    );
  }

  List<Color> _backgroudColor() {
    if (isSelected) {
      return [Colors.blue, Colors.blue];
    } else {
      return [Colors.white, Colors.white, Colors.white];
    }
  }

  TextButton _buildButton({Icon? icon}) {
    var text = Text(
      label,
      style: TextStyle(
          color: Colors.black,
          fontSize: params!.fontSize!,
          fontWeight: FontWeight.bold),
    );

    if (icon == null) {
      return TextButton(
        onPressed: onPressed,
        child: text,
      );
    }

    return TextButton.icon(
      icon: icon,
      onPressed: onPressed,
      label: text,
    );
  }
}

class CustomTextButtonParams {
  double allCircularBorderRadius;
  double? height;
  double? width;
  double? fontSize;

  CustomTextButtonParams(
      {this.height = 50,
      this.width = 250,
      this.fontSize = 20,
      this.allCircularBorderRadius = 50});
}
