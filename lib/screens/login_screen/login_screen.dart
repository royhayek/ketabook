import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/models/user_model.dart';
import 'package:ketabook/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:ketabook/screens/register_screen/register_screen.dart';
import 'package:ketabook/screens/tabs_screen/tabs_screen.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/custom_text_field.dart';
import 'package:ketabook/widgets/default_button.dart';
import 'package:ketabook/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  AppNotifier application;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);
  }

  _loginUser(BuildContext ctx) async {
    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
          msg: trans(context, 'please_fill_all_required_fields'),
          fontSize: getProportionateScreenWidth(14));
    } else {
      await loadingDialog(context).show();
      UserModel user = UserModel();
      user.email = email;
      user.password = password;

      FocusScope.of(context).requestFocus(FocusNode());
      await HttpService().loginUser(context, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Text(
              trans(context, 'welcome_back'),
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      fontSize: getProportionateScreenWidth(40),
                      color: Colors.black,
                    ),
                  ),
            ),
            SizedBox(height: getProportionateScreenHeight(56)),
            Text(
              trans(context, 'sign_in_to_continue'),
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      fontSize: getProportionateScreenWidth(17),
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF666666),
                    ),
                  ),
            ),
            SizedBox(height: getProportionateScreenHeight(40)),
            CustomTextField(
              label: trans(context, 'email_address_or_phone_no'),
              controller: emailController,
              inputType: TextInputType.emailAddress,
            ),
            SizedBox(height: getProportionateScreenHeight(25)),
            CustomTextField(
              obscure: true,
              label: trans(context, 'password'),
              controller: passwordController,
              inputType: TextInputType.text,
            ),
            SizedBox(height: getProportionateScreenHeight(25)),
            InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
              child: Text(
                trans(context, 'forgot_password?'),
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        fontSize: getProportionateScreenWidth(17),
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(25)),
            DefaultButton(
              text: trans(context, 'sign_in'),
              press: () => _loginUser(context),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultButton(
                  text: trans(context, 'skip'),
                  press: () {
                    auth.setUser(null);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TabsScreen()),
                    );
                  },
                  width: getProportionateScreenWidth(80),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  trans(context, 'don\'t_have_an_account?'),
                  style: Theme.of(context).textTheme.headline6.merge(
                        TextStyle(
                          fontSize: getProportionateScreenWidth(17),
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF666666),
                        ),
                      ),
                ),
                InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, RegisterScreen.routeName),
                  child: Text(
                    ' ${trans(context, 'sign_up_now')}',
                    style: Theme.of(context).textTheme.headline6.merge(
                          TextStyle(
                            fontSize: getProportionateScreenWidth(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(100)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
