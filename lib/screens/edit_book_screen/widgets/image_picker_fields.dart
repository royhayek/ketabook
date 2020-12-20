import 'package:flutter/material.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';

class ImagePickerFields extends StatelessWidget {
  const ImagePickerFields({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110,
      decoration: BoxDecoration(
        color: Color(0xFFEFEFF4),
        borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 50),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 10, 6, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trans(context, 'choose_photos'),
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      color: Color(0xFF8A8A8F),
                      fontWeight: FontWeight.w400,
                      fontSize: getProportionateScreenWidth(15),
                    ),
                  ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Row(
              children: [
                imagePickerSingleField(),
                imagePickerSingleField(),
                imagePickerSingleField(),
                imagePickerSingleField(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget imagePickerSingleField() {
    return Expanded(
      child: Container(
        height: 65,
        padding: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 50),
        ),
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 50),
          ),
          child: Icon(
            Icons.add,
            color: Color(0xFF8A8A8F),
          ),
        ),
      ),
    );
  }
}
