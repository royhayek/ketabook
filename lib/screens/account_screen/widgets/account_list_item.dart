import 'package:flutter/material.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/size_config.dart';

class AccountListItem extends StatelessWidget {
  final String title;
  final Icon icon;
  final Function onPressed;

  const AccountListItem({
    Key key,
    this.title,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      highlightColor: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: getProportionateScreenWidth(16),
              top: SizeConfig.screenHeight / 250,
            ),
            child: Row(
              children: [
                Container(
                  width: SizeConfig.screenWidth / 12,
                  height: SizeConfig.screenWidth / 12,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: icon,
                ),
                SizedBox(width: getProportionateScreenWidth(16)),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6.merge(
                        TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: getProportionateScreenWidth(17),
                        ),
                      ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: SizeConfig.screenWidth / 25,
                  color: Color(0xFFC8C7CC),
                )
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Color(0xFFEFEFF4),
            indent: getProportionateScreenWidth(48),
          )
        ],
      ),
    );
  }
}
