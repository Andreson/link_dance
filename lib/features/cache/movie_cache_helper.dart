import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class CachedManagerHelper {
  final BaseCacheManager _cacheManager = DefaultCacheManager();

  CachedManagerHelper();

  Future<VideoPlayerController> getControllerForVideo(String url) async {
    final fileInfo = await _cacheManager.getFileFromCache(url);

    if (fileInfo == null || fileInfo.file == null) {
      print('[VideoControllerService]: No video in cache');

      print('[VideoControllerService]: Saving video to cache');
      unawaited(_cacheManager.downloadFile(url));

      return VideoPlayerController.network(url);
    } else {
      print('[VideoControllerService]: Loading video from cache');
      return VideoPlayerController.file(fileInfo.file);
    }
  }

  Widget getImage(
      {required String url,
      double? width,
       double? height,
        Function(ImageProvider img)? onCache,
      BoxFit? fit = BoxFit.cover}) {
    return FutureBuilder<ImageProvider>(
        future: getImageFuture(url:url,onCache: onCache),
        builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
          if (snapshot.data == null) {
            return SizedBox();
          }

          return SizedBox(
            height: height,
            width: width,
            child: Image(fit: fit, image: snapshot.data!),
          );
        });
  }

  Future<ImageProvider> getImageFuture({required String url,Function(ImageProvider img)? onCache,}) async {
    final fileInfo = await _cacheManager.getFileFromCache(url);

    if (fileInfo == null || fileInfo.file == null) {
      print("------------------------- Fazendo cache da imagem ");
      unawaited(_cacheManager.downloadFile(url));
      var img = Image.network(url).image;
      if ( onCache!=null) {
        onCache(img);
      }
      return img;
    } else {

      var img = Image.file(fileInfo.file).image;
      if ( onCache!=null) {
        onCache(img);
      }
      return img;
    }
  }
}
