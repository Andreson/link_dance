import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:link_dance/core/dynamic_links/dynamic_link_router.dart';
import 'package:link_dance/core/helpers/constantes_config.dart';
import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:provider/provider.dart';

class DynamicLinkHelper {
  static const routerName = "routerDestination";

  static Future<void> retrieveDynamicLink({required BuildContext context,
    required PendingDynamicLinkData linkEvent}) async {
    try {
      var target = RoutesPages.values.byName(linkEvent.link.queryParameters[routerName]!);
      switch (target) {
        case RoutesPages.eventDetail:
          {
            DynamicLinkRoutes.eventRouter(context: context, linkEvent: linkEvent);
            break;
          }
        case RoutesPages.moviePlay:
          {
            DynamicLinkRoutes.movieRouter(context: context, linkEvent: linkEvent);
            break;
          }
      }
    } catch (e, trace) {
      print("Erro ao fazer redirect link $trace");
    }
  }

  static Future<String> createDynamicLink(
      {required DynamicLinkOptions options}) async {
    var parameters = DynamicLinkParameters(
        uriPrefix: ConstantsConfig.dynamicUrl,
        link: options.link,
        androidParameters: AndroidParameters(
          packageName: ConstantsConfig.packageName,
        ),
        iosParameters: IOSParameters(
          bundleId: ConstantsConfig.packageName,
          appStoreId: ConstantsConfig.applerStoreId,
        ),
        socialMetaTagParameters: SocialMetaTagParameters(

          title: options.title,
          imageUrl: Uri.parse(options.imageUrl),)
        );
    Uri url;
    if (options.shortUrl) {
      final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance
          .buildShortLink(parameters)
          .catchError((onError, trace) {
        print("Erro ao criar link dinamico curto  $onError |\n $trace");
      });
      url = shortLink.shortUrl;
    } else {
      url = await FirebaseDynamicLinks.instance
          .buildLink(parameters)
          .catchError((onError, trace) {
        print("Erro ao criar link dinamico $onError | \n $trace");
      });
    }

    return url.toString();
  }

  /**
   * Recebe um map e retorna uma string no formato '?param=value&param2=value2'
   */
  static String mapToQuery({required Map<String, dynamic> params}) {
    return params.entries.fold<String>(
        "?",
            (previousValue, element) =>
        "$previousValue&${element.key}=${element.value}");
  }


  static Map<String, dynamic> queryToMap({required String params}) {
    var index = params.indexOf("?") + 1;
    if (index > 1) {
      params = params.substring(index, params.length);
    }
    params = params.split("&").map((param) {
      var keyValue = param.split("=").join(":");
      return keyValue;
    }).join(",");
    return jsonDecode("{$params}");
  }
}

class DynamicLinkOptions {
  bool shortUrl;

  late RoutesPages router;
  late Map<String, dynamic> params;
  late String imageUrl;
  late String title;
  String? subTitle;
  late String _link;

  DynamicLinkOptions({
    this.shortUrl = true,
    required this.router,
    this.subTitle,
    required this.params,
    required this.imageUrl,
    required this.title,
    link = "https://linkdance.page.link/"
  }) :_link = link;

  Uri get link {
    var queryParams = DynamicLinkHelper.mapToQuery(params: params);
    var uriStr = "$_link$queryParams&${DynamicLinkHelper.routerName}=${router.name}";

    return Uri.parse(uriStr);
  }
}
