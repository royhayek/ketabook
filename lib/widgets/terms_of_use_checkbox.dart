import 'package:flutter/material.dart';
import 'package:ketabook/screens/information_screen/information_screen.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';

class TermsOfUseCheckbox extends StatelessWidget {
  final Function onTap;
  final bool agree;

  const TermsOfUseCheckbox({Key key, this.onTap, this.agree}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(SizeConfig.screenWidth / 18);
    print(SizeConfig.screenWidth / 14);
    return InkWell(
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: agree
                ? Icon(
                    Icons.check_circle_outline,
                    color: Colors.grey.shade300,
                    size: SizeConfig.screenWidth / 18,
                  )
                : Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CD964),
                    size: SizeConfig.screenWidth / 18,
                  ),
          ),
          SizedBox(width: getProportionateScreenWidth(8)),
          Text(
            '${trans(context, 'i_agree_to_the')} ',
            style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF666666),
                  ),
                ),
          ),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InformationScreen(title: 'terms_of_use'),
              ),
            ),
            child: Text(
              trans(context, 'terms_of_use'),
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      fontSize: getProportionateScreenWidth(15),
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
