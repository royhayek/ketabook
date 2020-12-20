import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/translation/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

String trans(BuildContext context, String text) {
  String translated;
  translated = AppLocalizations.of(context).translate(text);
  return translated;
}

bool isEnglish(BuildContext context) {
  AppNotifier application;
  application = Provider.of<AppNotifier>(context, listen: false);
  return application.getLanguage() == 'English';
}

bool validateEmail(String url) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(url);
}

String convertUnit(BuildContext context, int no) {
  if (no == 1)
    return isEnglish(context) ? '$no  ${trans(context, 'book')}' : 'كتاب';
  else if (no == 2)
    return isEnglish(context) ? '$no  ${trans(context, 'books')}' : 'كتابين';
  else if (no > 2 && no <= 10)
    return isEnglish(context) ? '$no  ${trans(context, 'books')}' : '$no كتب';
  else if (no > 10)
    return isEnglish(context) ? '$no  ${trans(context, 'books')}' : '$no كتاب';
  return '';
}

Widget swipeToRefresh(context,
    {Widget child,
    refreshController,
    VoidCallback onRefresh,
    VoidCallback onLoading}) {
  return SmartRefresher(
    enablePullDown: true,
    enablePullUp: true,
    controller: refreshController,
    onRefresh: onRefresh,
    onLoading: onLoading,
    footer: onLoading != null
        ? CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                // body = Text("No more products");
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("Load Failed! Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("release to load more");
              } else {
                body = Text("No more books");
              }
              return Container(
                height: 10.0,
                child: Center(child: body),
              );
            },
          )
        : CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                // body = Text("No more products");
              } else if (mode == LoadStatus.loading) {
                // body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                // body = Text("Load Failed! Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                // body = Text("release to load more");
              } else {
                // body = Text("No more books");
              }
              return Container(
                height: 10.0,
                child: Center(child: body),
              );
            },
          ),
    child: child,
  );
}

showImagePreviewDialog(BuildContext context, String image) {
  showDialog(
    context: context,
    builder: (_) => Material(
      type: MaterialType.transparency,
      child: Center(
        child: GestureDetector(
          child: Center(
            child: Hero(
              tag: 'imageHero',
              child: Image.network(WebService.getImageUrl() + image),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

showNeedLoginDialog(
    BuildContext context, String text, Function positive, Function negative) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 10),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, size: 50, color: kPrimaryColor),
            SizedBox(height: getProportionateScreenHeight(10)),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                  onPressed: negative,
                  color: kPrimaryColor,
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: getProportionateScreenHeight(15)),
                RaisedButton(
                  onPressed: positive,
                  color: kPrimaryColor,
                  child: Text('Login', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

showCustomDialog(
    BuildContext context, String text, Icon icon, Function positive) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 10),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(height: getProportionateScreenHeight(10)),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: getProportionateScreenHeight(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                  onPressed: positive,
                  color: kPrimaryColor,
                  child: Text(trans(context, 'close'),
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
