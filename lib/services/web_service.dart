import 'package:ketabook/my_config.dart';

class WebService {
  static String getWebService() {
    return MyConfig.DomainName + "webapi/";
  }

  static String getWebSite() {
    return MyConfig.DomainName;
  }

  static String getImageUrl() {
    return MyConfig.DomainName + "image/upload/";
  }
}
