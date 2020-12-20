import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/custom_text_field.dart';
import 'package:ketabook/widgets/default_button.dart';
import 'package:ketabook/widgets/progress_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = "/forgot_password_screen";

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = new TextEditingController();

  forgotPassword(BuildContext context) async {
    String email = emailController.text.trim().toLowerCase();
    if (email.isEmpty) {
      Fluttertoast.showToast(
          msg: trans(context, 'please_fill_all_required_fields'),
          fontSize: getProportionateScreenWidth(14));
    } else {
      await loadingDialog(context).show();
      HttpService().forgotPassword(context, email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.8,
        title: Text(
          trans(context, 'forgot_password'),
          style: Theme.of(context).appBarTheme.textTheme.headline5.merge(
                TextStyle(
                  fontSize: SizeConfig.screenWidth / 19,
                ),
              ),
        ),
        leading: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, size: SizeConfig.screenWidth / 15)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(40)),
            Text(
              trans(context, 'enter_your_email'),
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      fontSize: getProportionateScreenWidth(17),
                      color: Colors.black,
                    ),
                  ),
            ),
            SizedBox(height: getProportionateScreenHeight(38)),
            CustomTextField(
              label: trans(context, 'email_address'),
              controller: emailController,
              inputType: TextInputType.emailAddress,
            ),
            SizedBox(height: getProportionateScreenHeight(25)),
            DefaultButton(
              text: trans(context, 'send'),
              press: () => forgotPassword(context),
            ),
          ],
        ),
      ),
    );
  }
}
