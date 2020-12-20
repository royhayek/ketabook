import 'package:flutter/material.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/size_config.dart';

class CustomTextField extends StatelessWidget {
  final bool obscure;
  final String label;
  final TextEditingController controller;
  final TextInputType inputType;

  const CustomTextField({
    Key key,
    this.label,
    this.controller,
    this.obscure,
    this.inputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscure != null ? obscure : false,
      cursorColor: kPrimaryColor,
      style: TextStyle(
        fontSize: getProportionateScreenWidth(17),
      ),
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.6, color: Color(0xFFEFEFF4)),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.6, color: Color(0xFFEFEFF4)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.6, color: kPrimaryColor),
        ),
        labelStyle: Theme.of(context).textTheme.headline6.merge(
              TextStyle(
                fontSize: getProportionateScreenWidth(17),
                fontWeight: FontWeight.w400,
                color: Color(0xFF8A8A8F),
              ),
            ),
      ),
    );
  }
}
