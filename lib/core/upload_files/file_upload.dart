import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FileUpload {

  Future<FileUploadResponse> movieUpload(
      {required String filePath,
      String subFolder = "",
      required String rhythm,
      String? storageFileName}) async {
    var videoFormat = filePath.substring(filePath.length - 3, filePath.length);

    try {
      storageFileName = storageFileName ?? _generateMovieName();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('/movies/')
          .child(rhythm)
          .child(subFolder)
          .child(rhythm)
          .child('/$storageFileName.$videoFormat');
      final metadata = SettableMetadata(contentType: 'video/mp4');
      var task = ref.putFile(File(filePath), metadata);

      return Future.value(FileUploadResponse(ref, task, ref.fullPath));
    } catch (error) {
      print("putFile cath error $error");
      throw error;
    }
  }

  Future<ImageUploadResponse> imageUpload(
      {required String filePath,
      String subFolder = "",
      String? prefixName = "picture",
      bool makeThumbnail = false}) async {
    try {
      var temp = (await compressImagensUpload(path: filePath));

      var thumbnail = _fileUploadRef(
          file: temp['thumb']!, subFolder: subFolder);

      var banner = _fileUploadRef(file: temp['banner']!, subFolder: subFolder);

      return Future.value(
          ImageUploadResponse(banner: banner, thumbnail: thumbnail));
    }
    catch(err) {
      rethrow;
    }
  }

  Future<FileUploadResponse> fileUpload(
      {required File file,
      String subFolder = "",
      String? prefixName = "picture"}) async {
    return Future.value(_fileUploadRef(file: file));
  }

  FileUploadResponse _fileUploadRef(
      {required File file,
      String subFolder = "",
      String? prefixName = "picture"}) {
    try {
      var fileFormat =
          file.path.substring(file.path.length - 3, file.path.length);
      var storageFileName = "$prefixName-${_generateMovieName()}";
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('/pictures/')
          .child(subFolder)
          .child('/$storageFileName.$fileFormat');
      print("Ref fullPath upload file ${ref.fullPath}");

      print("Ref bucket upload file ${ref.bucket}");
      final metadata = SettableMetadata(contentType: "image/$fileFormat");
      var task = ref.putFile(file, metadata);
      return FileUploadResponse(ref, task, ref.fullPath);
    } catch (error) {
      print("putFile cath error $error");
      rethrow;
    }
  }

  //Reduz o tamanho da imagem e gera a miniatura
  Future<Map<String, File>> compressImagensUpload({required String path, int quality=60}) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(path);
    File imgBanner;
    File imgThumb = await FlutterNativeImage.compressImage(path,
        quality: 80, targetWidth: 270, targetHeight: 300);

    if (properties.width! > 2000) {
      imgBanner = await FlutterNativeImage.compressImage(path,percentage: 70,
        quality: 70,);
    } else {
      imgBanner = await FlutterNativeImage.compressImage(path,percentage: 80,
        quality: 80,);
      //imgBanner = await FlutterNativeImage.compressImage(path, quality: 90,percentage: 90);
      //imgBanner = File(path);
    }

    return {"banner": imgBanner, "thumb": imgThumb};
  }


  static Future<String?> generateThumbnailMovie(File movie) async {
    String? thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: movie.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 720,
      maxWidth: 640,
    );
    return thumbnailFile;
  }

  String _generateMovieName() {
    final DateTime now = DateTime.now();
    final int millSeconds = now.millisecondsSinceEpoch;
    final String month = now.month.toString();
    final String date = now.day.toString();
    final String storageId = (millSeconds.toString());
    final String today = ('$month$date');
    return "$today$storageId";
  }
}

class ImageUploadResponse {
  final FileUploadResponse _thumbnail;
  final FileUploadResponse _banner;

  ImageUploadResponse({
    required FileUploadResponse banner,
    required FileUploadResponse thumbnail,
  })  : _thumbnail = thumbnail,
        _banner = banner;

  FileUploadResponse get thumbnail => _thumbnail;

  FileUploadResponse get banner => _banner;
}

class FileUploadResponse {
  final Reference _ref;
  final UploadTask _task;
  final String _storageRef;

  FileUploadResponse(this._ref, this._task, this._storageRef);

  Reference get ref => _ref;

  UploadTask get task => _task;

  String get storageRef => _storageRef;
}
