import 'package:ketabook/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../size_config.dart';

ProgressDialog loadingDialog(BuildContext context) {
  final ProgressDialog pr = ProgressDialog(
    context,
    type: ProgressDialogType.Normal,
    isDismissible: false,
    showLogs: true,
  );

  pr.style(
    message: trans(context, 'please_wait'),
    borderRadius: 10.0,
    backgroundColor: Colors.white,
    elevation: 10.0,
    insetAnimCurve: Curves.easeInOut,
    progress: 0.0,
    progressWidgetAlignment: Alignment.center,
    textAlign: TextAlign.center,
    maxProgress: 100.0,
    padding: EdgeInsets.all(getProportionateScreenWidth(6)),
    progressTextStyle: TextStyle(
        color: Colors.black,
        fontSize: SizeConfig.screenWidth * 15,
        fontWeight: FontWeight.w400),
    messageTextStyle: TextStyle(
        color: Colors.black,
        fontSize: getProportionateScreenWidth(18),
        fontWeight: FontWeight.w600),
  );

  return pr;
}
