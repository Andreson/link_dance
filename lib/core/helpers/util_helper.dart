import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_dance/core/dynamic_links/dynamic_links_helper.dart';
import 'package:share_plus/share_plus.dart';

void shareContent(
    {required BuildContext context,
    required DynamicLinkOptions options}) async {
  final box = context.findRenderObject() as RenderBox?;
  var file = await DefaultCacheManager().getSingleFile(options.imageUrl);
  final urlPreview =
      await DynamicLinkHelper.createDynamicLink(options: options);
  await Share.shareXFiles([XFile(file.path)],
      text: "${options.title} $urlPreview",
      subject: options.subTitle,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
}
