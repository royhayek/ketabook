import 'package:flutter/material.dart';
import 'package:ketabook/size_config.dart';

class ContactListItem extends StatelessWidget {
  final String title;
  final String value;
  final Icon icon;

  const ContactListItem({Key key, this.title, this.value, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        SizedBox(width: getProportionateScreenHeight(15)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(18),
                    ),
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w400,
                      fontSize: getProportionateScreenWidth(15),
                    ),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
