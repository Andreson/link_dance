import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/helpers/constantes_images.dart';
import 'package:link_dance/features/event/components/event_item_list.dart';
import 'package:link_dance/components/input_fields/text_buton.dart';
import 'package:link_dance/components/not_found_card.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../components/widgets/imagem_avatar_component.dart';
import '../core/theme/fontStyles.dart';
import '../core/theme/theme_data.dart';
import 'helpers/constants_api.dart';

typedef ItemBuild = Widget Function(Object data);

FutureBuilder futureBuilderList<T>(
    {required BuildContext context,
    Future? loadDataFuture,
    required ItemBuild itemBuild,
    ScrollController? controller,
    List<dynamic>? initialData,
    required Future<void> Function() refreshData}) {
  return FutureBuilder(
    initialData: initialData,
    future: loadDataFuture,
    builder: ((context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.error != null) {
        print(" Erro ao carregar lista de professores ${snapshot.error}");
        return const Center(
          child: Text('Ocorreu um erro!'),
        );
      } else {
        return Consumer<T>(
          builder: (context, Repository, child) => RefreshIndicator(
            onRefresh: refreshData,
            child: ListView.builder(
                controller: controller,
                shrinkWrap: false,
                itemCount: (Repository as BaseRepository).listData.length,
                itemBuilder: (BuildContext context, int index) {
                  if (Repository.listData.isEmpty) {
                    return DataNotFoundComponent();
                  }

                  return itemBuild(Repository.listData[index]);
                }),
          ),
        );
      }
    }),
  );
}

FutureBuilder futureBuilderGrid<T>(
    BuildContext context, Future? loadDataFuture, ItemBuild itemBuild,
    {required Future<void> Function() refreshData,
    ScrollController? scrollController}) {
  return FutureBuilder(
    future: loadDataFuture,
    builder: ((context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        print("snapshot ${snapshot.stackTrace}");
        return const Center(
          child: Text('Ocorreu um erro!'),
        );
      } else {
        return Consumer<T>(
          builder: (context, repository, child) => RefreshIndicator(
            onRefresh: refreshData,
            child: GridView.builder(
                scrollDirection: Axis.vertical,
                controller: scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 5,
                ),
                itemCount: (repository as BaseRepository).listData.length,
                itemBuilder: (BuildContext context, int index) {
                  return itemBuild(repository.listData[index]);
                }),
          ),
        );
      }
    }),
  );
}

TextInputFormatter currencyMask() {
  return CurrencyTextInputFormatter(symbol: "R\$ ", locale: "pt");
}

Widget buildButton(
    {String label = "Enviar",
    required VoidCallback onPressed,
    CustomTextButtonParams? params}) {
  var defaultParam =
      CustomTextButtonParams(fontSize: 15, height: 40, width: 150);
  return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 0.0, top: 20.0),
      child: CustomTextButton(
          params: params ?? defaultParam, onPressed: onPressed, label: label));
}

TextInputFormatter phoneMask({String? initValue = ""}) {
  return MaskTextInputFormatter(
      initialText: initValue,
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
}

TextInputFormatter hourMask() {
  return MaskTextInputFormatter(
      mask: '##:##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
}

TextInputFormatter dateMask() {
  return MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
}

TextInputFormatter postalCodeMask() {
  return MaskTextInputFormatter(
      mask: '##.###-###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
}

TextInputFormatter mailMask() {
  return MaskTextInputFormatter(
      mask: '.(?=.*...@)',
      filter: {
        "#": RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      },
      type: MaskAutoCompletionType.lazy);
}

Future onLoading(BuildContext context,
    {String text = "Processando",
    Stream<TaskSnapshot>? stream,
    String actionMesage = "Processando"}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
          backgroundColor: Colors.white,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              height: stream == null ? 200 : 250,
              width: 250,
              child: Column(
                children: [
                  // The loading indicator
                  Text(
                    actionMesage,
                    style: const TextStyle(color: Colors.black),
                  ),
                  Image.asset(
                    "assets/images/bebe-dancando.gif",
                    height: 125.0,
                    width: 125.0,
                  ),
                  // Some text
                  SizedBox(
                    height: 50,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText('6',
                            textStyle: _animadedTextStyle(),
                            speed: _timeTextAnimation()),
                        TyperAnimatedText('7',
                            textStyle: _animadedTextStyle(),
                            speed: _timeTextAnimation()),
                        TyperAnimatedText('8',
                            textStyle: _animadedTextStyle(),
                            speed: _timeTextAnimation()),
                        TyperAnimatedText('vaaaaaaaai!',
                            textStyle: _animadedTextStyle(),
                            speed: _timeTextAnimation()),
                      ],
                      repeatForever: true,
                    ),
                  ),
                  if (stream != null) buildProgress(stream, context),
                ],
              ),
            ),
          ));
    },
  );
}

Duration _timeTextAnimation() {
  return const Duration(milliseconds: 1);
}

TextStyle _animadedTextStyle() {
  return const TextStyle(fontSize: 18, color: Colors.black);
}

Future<void> showWarning(BuildContext context,
    {String content = "Ocorreu um erro nao esperado ao realizar operação!",
    VoidCallback? onPressed}) {
  onPressed = onPressed ?? () => {Navigator.of(context).pop()};
  var titleWidget = Row(
    children:   [
      const Icon(FontAwesomeIcons.triangleExclamation, color: Colors.yellow),
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
      const Icon(FontAwesomeIcons.bug, color: Colors.red,),
      sizedBoxH10(),
      const Text("Vish, deu ruim", style: kTitleText)
    ],
  );
  return dialog(context, titleWidget, content, "Ok", onPressed);
}

Future showSuccess(BuildContext context,
    {String content = "Operação realizada com sucesso!",
      VoidCallback? onPressed}) {
  onPressed = onPressed ?? () => {Navigator.of(context).pop()};
  var titleWidget = Row(
    children: [
      const Icon(Icons.check_circle_outline, color: Colors.lightGreen,),
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
      const Icon(FontAwesomeIcons.info, color: Colors.blueAccent,),
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

Widget progressIndicator({double progress = 1, double width = 150}) {
  return LinearPercentIndicator(
    alignment: MainAxisAlignment.center,
    addAutomaticKeepAlive: true,
    barRadius: const Radius.circular(10),
    animation: true,
    width: width,
    lineHeight: 20.0,
    center: Text("${(100 * progress).round()} %"),
    percent: progress,
    backgroundColor: Colors.black,
    progressColor: Colors.blue,
  );
}

Widget buildProgress(Stream<TaskSnapshot>? stream, BuildContext superContext) {
  return StreamBuilder<TaskSnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return progressIndicator(progress: progress);
        }
        return progressIndicator(progress: 0);
      });
}

Text tagRequired() {
  return const Text("*",
      style: TextStyle(
          fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold));
}

Widget labelRequired({required bool required, required String label}) {
  var textLabel = Text(label);
  var isRequired = required
      ? tagRequired()
      : const Text(
          ""); // Text(required? "*" :"",style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),);
  return Row(children: [
    textLabel,
    Padding(padding: EdgeInsets.only(left: 5), child: isRequired)
  ]);
}

SnackBar snackBar({String mensage = "Operação realizada com sucesso!"}) {
  return SnackBar(
    content: Text(mensage, style: kInfoText),
    backgroundColor: (Colors.black12),
    action: SnackBarAction(
      label: 'Fechar',
      onPressed: () {},
    ),
  );
}

Widget imageNetwork({required String url}) {
  return Image.network(
    url,
    fit: BoxFit.cover,
    errorBuilder: (_, child, loading) => errorBuilder(),
    loadingBuilder: (_, child, progress) =>
        progress == null ? child : loadBuilder(progress),
  );
}

loadBuilder(ImageChunkEvent progress) {
  return SizedBox(
    height: 160,
    width: 240,
    child: Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(
          color: Colors.white,
          value: progress.cumulativeBytesLoaded / progress.expectedTotalBytes!,
        ),
      ),
    ),
  );
}

/**
 * Copia um dado para a area de transferencia e mostra um snack bar de confirmação
 */
void copyClipboardData(String data, BuildContext context,
    {String mensage = "Campo copiado"}) {
  Clipboard.setData(ClipboardData(text: data)).then((value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 300,
        backgroundColor: (Colors.black12),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 2,
        duration: const Duration(seconds: 1),
        content: Text(mensage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ))));
  });
}

errorBuilder() {
  return SizedBox(
    height: 160,
    width: 240,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
        ),
        Text(
          "Nao e possivel abrir imagem!",
        )
      ],
    ),
  );
}

void modalBottomScroll(
    {required Widget child,
    required BuildContext context,
    bool isFullScreen = true}) {
  var body = isFullScreen
      ? SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: child),
        )
      : child;
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: child));
}

Widget buttonNewRegistry({required void Function() onPressed}) {
  return IconButton(onPressed: onPressed, icon: iconNewRegistry);
}

Widget buttonSaveRegistry({required void Function() onPressed}) {
  return IconButton(onPressed: onPressed, icon: iconSaveRegistry);
}

Widget leadingToBackScaffold({required void Function() onPressed}) {
  return IconButton(
      icon: const Icon(FontAwesomeIcons.chevronLeft), onPressed: onPressed);
}

ImageAvatarComponent getImageProfile(
    {String? imageUrl,
    String? imageLocal,
    required Function(String path) changeImage}) {
  return ImageAvatarComponent(
    imageLocal: imageLocal ?? ConstantsImagens.defaultAvatar,
    imageUrl: imageUrl,
    selectImage: changeImage,
  );
}
