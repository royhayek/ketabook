import 'package:flutter/material.dart';
import 'package:ketabook/size_config.dart';

class SearchTextField extends StatelessWidget {
  final String label;
  final Function onChanged;
  final TextEditingController controller;
  final Function onSubmitted;

  const SearchTextField({
    Key key,
    this.label,
    this.onChanged,
    this.controller,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 125),
      borderSide: BorderSide(color: Colors.transparent),
      gapPadding: 10,
    );

    return SizedBox(
      height: SizeConfig.screenHeight / 14,
      child: Center(
        child: TextFormField(
          onFieldSubmitted: onSubmitted,
          onChanged: onChanged,
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    fontSize: SizeConfig.screenWidth / 22,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8A8A8F),
                  ),
                ),
            alignLabelWithHint: false,
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            border: outlineInputBorder,
            contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(4),
            ),
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  SizeConfig.screenWidth / 40,
                  SizeConfig.screenHeight / 82,
                  SizeConfig.screenWidth / 60,
                  SizeConfig.screenHeight / 82,
                ),
                child: ImageIcon(
                  AssetImage('assets/images/ic_search.png'),
                  size: SizeConfig.screenWidth / 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
