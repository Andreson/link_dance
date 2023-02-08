import 'package:flutter/material.dart';
import 'package:link_dance/core/helpers/constantes_images.dart';
import 'package:link_dance/core/helpers/movie_cache_helper.dart';
import 'package:link_dance/core/helpers/constants_api.dart';

class ImagemCardComponent extends StatelessWidget {
  ImagemCardComponent({
    Key? key,
    required this.imagemURL,
    this.imagemAsset = ConstantsImagens.defaultAvatar
  }) : super(key: key);
  CachedManagerHelper cachedManager = CachedManagerHelper();

  String? imagemURL;
  final String imagemAsset;

  @override
  Widget build(BuildContext context) {
    Widget imagem;
    if (imagemURL != null) {
      imagem = cachedManager.getImage(
        url: imagemURL!,
      );
    }
    else {
      imagem =  Image.asset(imagemAsset);
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
