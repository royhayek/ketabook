import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ketabook/models/slideshow.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerListItem extends StatelessWidget {
  final Slideshow slideshow;

  const BannerListItem({Key key, this.slideshow}) : super(key: key);

  _launchURL(String imgLink) async {
    if (await canLaunch(imgLink)) {
      await launch(imgLink);
    } else {
      throw 'Could not launch $imgLink';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(slideshow.imgLink),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 5),
            width: getProportionateScreenWidth(336),
            child: Card(
              elevation: 5,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenWidth / 50),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: '${WebService.getImageUrl()}${slideshow.name}',
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Container(
                  //   decoration: new BoxDecoration(
                  //     borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 50),
                  //     gradient: new LinearGradient(
                  //       colors: [
                  //         Colors.black.withOpacity(0.4),
                  //         Colors.grey.withOpacity(0.1),
                  //       ],
                  //       stops: [0.0, 1.0],
                  //       begin: FractionalOffset.bottomCenter,
                  //       end: FractionalOffset.topCenter,
                  //       tileMode: TileMode.repeated,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
