import 'package:flutter/material.dart';
import 'package:ketabook/models/college.dart';
import 'package:ketabook/screens/books_screen/books_screen.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';

class FacultyListItem extends StatelessWidget {
  final College faculty;

  const FacultyListItem({Key key, this.faculty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BooksScreen(implyLeading: true, college: faculty),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(right: getProportionateScreenWidth(9)),
        child: Column(
          children: [
            Padding(
              padding: isEnglish(context)
                  ? EdgeInsets.only(right: getProportionateScreenWidth(16))
                  : EdgeInsets.only(left: getProportionateScreenWidth(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 3),
                    width: SizeConfig.screenWidth / 4,
                    height: SizeConfig.screenHeight / 8,
                    child: Card(
                      margin: EdgeInsets.all(2),
                      elevation: 5,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.screenWidth / 50),
                      ),
                      child: Image.network(
                        '${WebService.getImageUrl()}${faculty.photo}',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(16)),
                  Expanded(
                    child: Text(
                      isEnglish(context) ? faculty.nameEn : faculty.nameAr,
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(16),
                            ),
                          ),
                    ),
                  ),
                  Icon(
                    isEnglish(context)
                        ? Icons.keyboard_arrow_right
                        : Icons.keyboard_arrow_left,
                    color: Color(0xFFC8C7CC),
                    size: 20,
                  ),
                ],
              ),
            ),
            Divider(
              height: 2,
              indent: 100,
              thickness: 1,
              color: Color(0xFFEFEFF4),
            )
          ],
        ),
      ),
    );
  }
}
