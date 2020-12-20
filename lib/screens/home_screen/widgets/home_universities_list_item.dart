import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ketabook/models/university.dart';
import 'package:ketabook/screens/faculties_screen/faculties_screen.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/size_config.dart';

class HomeUniversityListItem extends StatelessWidget {
  final University university;

  const HomeUniversityListItem({Key key, this.university}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: SizeConfig.screenWidth / 45),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FacultiesScreen(
              university: university,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(bottom: SizeConfig.screenHeight / 90),
          width: SizeConfig.screenWidth / 4,
          child: Card(
            margin: EdgeInsets.all(2),
            elevation: 4,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 50),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(SizeConfig.screenHeight / 90),
                  child: CachedNetworkImage(
                    imageUrl: '${WebService.getImageUrl()}${university.photo}',
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                // Container(
                //   decoration: new BoxDecoration(
                //     borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 50),
                //     gradient: new LinearGradient(
                //       colors: [
                //         Colors.black.withOpacity(0.5),
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
      ),
    );
  }
}
