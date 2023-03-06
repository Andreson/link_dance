import 'package:link_dance/core/helpers/constants_api.dart';

class ConstantsConfig {

  static const String dynamicLinkUrlDev = "linkdance.page.link";
  static const String dynamicLinkUrlProd = "dynamic.linkdance.com.br";

  static String get dynamicUrl => ConstantsAPI.env=="dev"?dynamicLinkUrlDev : dynamicLinkUrlProd;
  static String get packageName => "br.com.link_dance.link_dance";
  static const String applerStoreId = "0";

  static String userAuthData="userAuthData";
  static String userTeacherData="userTeacherData";
  static const int pageSize=15;

}