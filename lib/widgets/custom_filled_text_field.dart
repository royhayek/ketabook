import 'package:flutter/material.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';

class CustomFilledTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType inputType;
  final double height;
  final bool enabled;

  const CustomFilledTextField({
    Key key,
    this.hint,
    this.controller,
    this.obscure,
    this.height,
    this.inputType,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height != null ? height : 42,
      decoration: BoxDecoration(
        color: Color(0xFFEFEFF4),
        borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 50),
      ),
      child: TextField(
        enabled: enabled != null ? enabled : true,
        controller: controller,
        obscureText: obscure != null ? obscure : false,
        keyboardType: inputType != null ? inputType : TextInputType.text,
        textAlign: isEnglish(context) ? TextAlign.left : TextAlign.right,
        textDirection:
            isEnglish(context) ? TextDirection.ltr : TextDirection.rtl,
        minLines: 1, //Normal textInputField will be displayed
        maxLines: hint == trans(context, 'description') ? 3 : 1,
        cursorColor: kPrimaryColor,
        style: TextStyle(
          fontSize: SizeConfig.screenWidth / 20,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          alignLabelWithHint: false,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.fromLTRB(
            SizeConfig.screenWidth * 0.01,
            SizeConfig.screenWidth * 0.01,
            SizeConfig.screenWidth * 0.01,
            SizeConfig.screenWidth * 0.02,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Color(0xFF8A8A8F),
            fontWeight: FontWeight.w400,
            fontSize: getProportionateScreenWidth(15),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
