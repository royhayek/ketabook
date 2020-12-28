import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ketabook/models/user_model.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/custom_text_field.dart';
import 'package:ketabook/widgets/default_button.dart';
import 'package:ketabook/widgets/progress_dialog.dart';
import 'package:ketabook/widgets/terms_of_use_checkbox.dart';
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = "/register_screen";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateFormat timeFormat = DateFormat('kk:mm:ss');
  bool agree = false;

  _registerUser(BuildContext ctx) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim();
    String address = addressController.text.trim();

    if (agree) {
      Toast.show(trans(context, 'you_need_to_agree_to_terms_of_use'), context);
      return;
    }

    if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      Toast.show(trans(context, 'please_fill_all_required_fields'), context);
    } else {
      if (!validateEmail(email)) {
        Toast.show(trans(context, 'please_enter_a_valid_email'), context);
        return;
      }
      await loadingDialog(context).show();

      UserModel user = UserModel();
      user.name = name;
      user.email = email;
      user.password = password;
      user.phone = phone;
      user.address = address;
      user.dateJoin = dateFormat.format(DateTime.now());
      user.timeJoin = timeFormat.format(DateTime.now());
      user.universityId = '';
      user.statusCode = '1';
      user.dob = '';
      user.gender = '';
      user.id = '';

      FocusScope.of(context).requestFocus(FocusNode());
      HttpService().registerUser(context, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, size: SizeConfig.screenWidth / 14)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              Text(
                trans(context, 'Welcome'),
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        fontSize: getProportionateScreenWidth(40),
                        color: Colors.black,
                      ),
                    ),
              ),
              SizedBox(height: getProportionateScreenHeight(56)),
              Text(
                trans(context, 'sign_up_to_join'),
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        fontSize: getProportionateScreenWidth(17),
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF666666),
                      ),
                    ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              CustomTextField(
                label: trans(context, 'name'),
                controller: nameController,
                inputType: TextInputType.name,
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              CustomTextField(
                label: trans(context, 'email_address'),
                controller: emailController,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              CustomTextField(
                obscure: true,
                label: trans(context, 'password'),
                controller: passwordController,
                inputType: TextInputType.text,
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              CustomTextField(
                label: trans(context, 'phone_no'),
                controller: phoneController,
                inputType: TextInputType.phone,
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              CustomTextField(
                label: trans(context, 'address'),
                controller: addressController,
                inputType: TextInputType.text,
              ),
              SizedBox(height: getProportionateScreenHeight(18)),
              TermsOfUseCheckbox(
                agree: agree,
                onTap: () {
                  setState(() {
                    agree = !agree;
                  });
                },
              ),
              SizedBox(height: getProportionateScreenHeight(25)),
              DefaultButton(
                text: trans(context, 'sign_up'),
                press: () => _registerUser(context),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${trans(context, 'have_an_account')} ',
                    style: Theme.of(context).textTheme.headline6.merge(
                          TextStyle(
                            fontSize: getProportionateScreenWidth(17),
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                          ),
                        ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      trans(context, 'sign_in_now'),
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
      ),
    );
  }
}
