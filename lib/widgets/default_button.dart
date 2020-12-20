import 'package:flutter/material.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Function press;
  final String total;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final double width;
  final bool loading;

  const DefaultButton({
    Key key,
    this.text,
    this.press,
    this.total,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.width,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null ? width : double.infinity,
      height: getProportionateScreenHeight(55),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 50),
          side: borderColor != null
              ? BorderSide(
                  color: kPrimaryColor, width: 0.8, style: BorderStyle.solid)
              : BorderSide(
                  color: Colors.transparent,
                  width: 0,
                  style: BorderStyle.solid),
        ),
        color: backgroundColor != null ? backgroundColor : kPrimaryColor,
        onPressed: !loading ? press : () => null,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: !loading
                  ? Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(17),
                        fontFamily: 'SfProText',
                        fontWeight: FontWeight.w400,
                        color: textColor != null ? textColor : Colors.white,
                      ),
                    )
                  : SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
            ),
            total != null
                ? Align(
                    alignment: isEnglish(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      total,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(17),
                        fontFamily: 'SfProText',
                        fontWeight: FontWeight.w400,
                        color: textColor != null ? textColor : Colors.white,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
