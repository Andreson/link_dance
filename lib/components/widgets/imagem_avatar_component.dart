import 'dart:io';

import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/cache/movie_cache_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImageAvatarComponent extends StatefulWidget {
  String? imageUrl;
  String? imageLocal;
  String? path;

  Function(String path)? selectImage;
   bool readOnly;
  ImageAvatarComponent(
      {Key? key,
      this.imageUrl,
        this.readOnly=false,
      this.selectImage,
      this.imageLocal = Constants.defaultAvatar})
      : super(key: key);

  @override
  State<ImageAvatarComponent> createState() => _ImageAvatarState();
}

class _ImageAvatarState extends State<ImageAvatarComponent> {
  final CachedManagerHelper cachedManager = CachedManagerHelper();

  Widget? boxImage;



  @override
  void didChangeDependencies() {


    _getImage().then((value) {


      setState((){
        boxImage = SizedBox(
            height: 150,
            width: 150,
            child: CircleAvatar(
              backgroundImage: value,
              radius: 200.0,
            ));
      });

    });
    super.didChangeDependencies();
  }
  @override
  void initState() {
    // TODO: implement initState

    _getImage().then((value) {

      setState((){
        boxImage = SizedBox(
            height: 150,
            width: 150,
            child: CircleAvatar(
              backgroundImage: value,
              radius: 200.0,
            ));
      });

    });
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement initState

    return Stack(
      children: [
        boxImage ?? CircularProgressIndicator(),
        if(!widget.readOnly)
        Positioned(
            top: 115,
            left: 40,
            child: TextButton(
                onPressed: () {
                  _callFilePicker().then((pickerResult) {
                    if (pickerResult?.files != null &&
                        pickerResult!.files.isNotEmpty) {
                      setState(() {
                        boxImage = SizedBox(
                            height: 150,
                            width: 150,
                            child: CircleAvatar(
                              backgroundImage: Image.file(File(pickerResult.files.single.path!)).image,
                              radius: 200.0,
                            ));
                      });
                            widget.selectImage!(pickerResult.files.single.path!);
                    }
                  });
                },
                child: const Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      "alterar",
                      style: TextStyle(color: Colors.white, shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.5, 1),
                          blurRadius: 1.0,
                          color: Colors.black,
                        )
                      ]),
                    ),
                  ),
                ))),
      ],
    );
  }

  Future<FilePickerResult?> _callFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      widget.path = result.files.single.path!;

      return result;
    } else {
      return null;
    }
  }
  Future<ImageProvider> _getImage() async{
    ImageProvider image;

    var imageLocal = widget.imageLocal ?? Constants.defaultAvatar;


    if (imageLocal.contains("assets")) {
      widget.path =imageLocal;
      image = Image.asset(imageLocal).image;
    } else {
      widget.path =widget.imageLocal;
      image = Image.file(File(imageLocal)).image;
    }
    if (widget.imageUrl != null && widget.imageUrl!.trim().isNotEmpty) {
      widget.path =widget.imageUrl;

      image =await cachedManager.getImageFuture(url:widget.imageUrl!);

    }

    return image;
  }
}
