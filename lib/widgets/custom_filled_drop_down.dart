import 'package:flutter/material.dart';
import 'package:ketabook/size_config.dart';

class CustomFilledDropDown extends StatelessWidget {
  final String hint;
  final double height;
  final List<DropdownMenuItem> items;
  final String selectedValue;
  final Function onChanged;
  final bool enabled;

  const CustomFilledDropDown({
    Key key,
    this.hint,
    this.height,
    this.items,
    this.selectedValue,
    this.onChanged,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height != null ? height : SizeConfig.screenHeight / 40,
      decoration: BoxDecoration(
        color: Color(0xFFEFEFF4),
        borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 50),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
        child: SizedBox(
          child: DropdownButtonFormField<String>(
            isDense: false,
            itemHeight: 60,
            decoration: InputDecoration.collapsed(hintText: ''),
            style: TextStyle(
              fontSize: SizeConfig.screenWidth / 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            hint: Text(
              hint,
              style: TextStyle(
                color: Color(0xFF8A8A8F),
                fontWeight: FontWeight.w400,
                fontSize: getProportionateScreenWidth(15),
              ),
            ),
            onChanged: onChanged,
            items: items,
            value: selectedValue,
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}
