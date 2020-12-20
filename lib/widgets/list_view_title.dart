import 'package:flutter/material.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';

class ListViewTitle extends StatelessWidget {
  final String title;
  final Function function;

  const ListViewTitle({Key key, this.title, this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: isEnglish(context)
            ? EdgeInsets.only(right: getProportionateScreenWidth(16))
            : EdgeInsets.only(left: getProportionateScreenWidth(16)),
        child: Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline5.merge(
                    TextStyle(fontSize: SizeConfig.screenWidth / 20),
                  ),
            ),
            Spacer(),
            Text(
              trans(context, 'see_all'),
              style: Theme.of(context).textTheme.headline5.merge(
                    TextStyle(
                      fontSize: SizeConfig.screenWidth / 27,
                      color: Color(
                        0xFF8A8A8F,
                      ),
                    ),
                  ),
            ),
            Icon(
              isEnglish(context)
                  ? Icons.keyboard_arrow_right
                  : Icons.keyboard_arrow_left,
              size: SizeConfig.screenWidth / 25,
              color: Color(0xFF8A8A8F),
            )
          ],
        ),
      ),
    );
  }
}
