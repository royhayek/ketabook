import 'package:flutter/material.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';

class BookImageListItem extends StatelessWidget {
  final String imageName;

  const BookImageListItem({Key key, this.imageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showImagePreviewDialog(context, imageName);
      },
      child: Hero(
        tag: 'imageHero',
        child: Container(
          padding: EdgeInsets.only(bottom: 15),
          width: getProportionateScreenWidth(105),
          // height: getProportionateScreenHeight(100),
          child: Card(
            margin: EdgeInsets.only(right: 15),
            elevation: 5,
            color: Color(0xFFC8C7CC),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Image.network(
                  '${WebService.getImageUrl()}$imageName',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
