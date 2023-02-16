import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/components/input_fields/text_buton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/theme/fontStyles.dart';



Future<void> showWarning(BuildContext context,
    {String content = "Ocorreu um erro nao esperado ao realizar operação!",
      VoidCallback? onPressed}) {
  onPressed = onPressed ?? () => {Navigator.of(context).pop()};
  var titleWidget = Row(
    children: [
      const Icon(FontAwesomeIcons.triangleExclamation, color: Colors.yellow, size: iconDialogSize,),
      sizedBoxH10(),
      const Text("Algo de errado não está certo", style: kTitleText)
    ],
  );
  return dialog(context, titleWidget, content, "Ok", onPressed);
}

Future<void> showError(BuildContext context,
    {String content = "Ocorreu um erro nao esperado ao realizar operação!",
      VoidCallback? onPressed}) {
  onPressed = onPressed ?? () => {Navigator.of(context).pop()};
  var titleWidget = Row(
    children: [
      const Icon(
        FontAwesomeIcons.bug,
        color: Colors.red,
        size: iconDialogSize,
      ),
      sizedBoxH10(),
      const Text("Vish, deu ruim", style: kTitleText)
    ],
  );
  return dialog(context, titleWidget, content, "Ok", onPressed);
}

Future showConfirm(BuildContext context,
    {required String content,
      required VoidCallback confirmAction,
      VoidCallback? cancelAction}) {
  cancelAction = cancelAction ?? () => {Navigator.of(context).pop()};
  var titleWidget = Row(
    children: [
      Icon(
        FontAwesomeIcons.personCircleQuestion,
        color: Colors.deepPurple[200],
        size: 30,
      ),
      sizedBoxH10(),
      const Text("Então né", style: kTitleText)
    ],
  );
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      elevation: 2,
      title: titleWidget,
      content: Text(content, style: kInfoText),
      actions: [
        CustomTextButton(
            onPressed: confirmAction,
            label: "Sim",
            backgroudColor: [Colors.redAccent[100]!, Colors.redAccent[200]!],
            params:
            CustomTextButtonParams(fontSize: 15, height: 40, width: 100)),
        CustomTextButton(
            onPressed: cancelAction,
            label: "Cancelar",
            backgroudColor: [Colors.lightBlue[100]!,Colors.lightBlue[200]!],
            params:
            CustomTextButtonParams(fontSize: 15, height: 40, width: 100)),
      ],
    ),
  );
}

Future showSuccess(BuildContext context,
    {String content = "Operação realizada com sucesso!",
      VoidCallback? onPressed}) {
  onPressed = onPressed ?? () => {Navigator.of(context).pop()};
  var titleWidget = Row(
    children: [
      const Icon(
        Icons.check_circle_outline,
        color: Colors.lightGreen,
      ),
      sizedBoxH10(),
      const Text("Aêêêêêêêêêêê", style: kTitleText)
    ],
  );
  return dialog(context, titleWidget, content, "Ok", onPressed);
}

Future<void> showInfo(
    {required BuildContext context,
      required String content,
      String title = "Aviso",
      String labelButton = "Ok",
      VoidCallback? onPressed}) async {
  onPressed ??= () => Navigator.of(context).pop();
  var titleWidget = Row(
    children: [
      const Icon(
        FontAwesomeIcons.info,
        color: Colors.blueAccent,
      ),
      Text(title, style: kTitleText)
    ],
  );
  return dialog(context, titleWidget, content, labelButton, onPressed);
}

Future<void> dialog(BuildContext context, Widget title, String content,
    String labelButton, VoidCallback onPressed) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      elevation: 2,
      title: title,
      content: Text(content, style: kInfoText),
      actions: [
        CustomTextButton(
            onPressed: onPressed,
            label: labelButton,
            params:
            CustomTextButtonParams(fontSize: 15, height: 40, width: 100)),
      ],
    ),
  );
}
