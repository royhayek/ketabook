import 'package:flutter/material.dart';

import '../../../size_config.dart';

class LanguageListItem extends StatelessWidget {
  final String title;
  final String icon;
  final Function onTap;

  const LanguageListItem({Key key, this.title, this.icon, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(fontSize: getProportionateScreenWidth(18)),
      ),
      leading: Image.asset(
        icon,
        width: SizeConfig.screenWidth / 13,
      ),
    );
  }
}
