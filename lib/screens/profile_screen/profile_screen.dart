import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ketabook/models/user_model.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/custom_filled_text_field.dart';
import 'package:ketabook/widgets/default_button.dart';
import 'package:ketabook/widgets/progress_dialog.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/screens/login_screen/login_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile_screen";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateFormat timeFormat = DateFormat('kk:mm:ss');

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  UserModel _user;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _getUserInfo();
  }

  _getUserInfo() async {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user != null)
      HttpService().getUserInfo().then((value) {
        setState(() {
          _user = value;
          _nameController.text = _user.name;
          _emailController.text = _user.email;
          _passwordController.text = _user.password;
          _phoneController.text = _user.phone;
          _addressController.text = _user.address;
        });
      }).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    else
      Navigator.popUntil(context, ModalRoute.withName(LoginScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                trans(context, 'my_profile'),
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(30),
                      ),
                    ),
              ),
              SizedBox(height: getProportionateScreenHeight(50)),
              !_isLoading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFilledTextField(
                          height: SizeConfig.screenHeight / 16,
                          hint: trans(context, 'name'),
                          controller: _nameController,
                        ),
                        SizedBox(height: getProportionateScreenHeight(15)),
                        CustomFilledTextField(
                          height: SizeConfig.screenHeight / 16,
                          hint: trans(context, 'email_address'),
                          controller: _emailController,
                        ),
                        SizedBox(height: getProportionateScreenHeight(15)),
                        CustomFilledTextField(
                          height: SizeConfig.screenHeight / 16,
                          hint: trans(context, 'phone_no'),
                          controller: _phoneController,
                        ),
                        SizedBox(height: getProportionateScreenHeight(15)),
                        CustomFilledTextField(
                          height: SizeConfig.screenHeight / 16,
                          obscure: true,
                          hint: trans(context, 'password'),
                          controller: _passwordController,
                        ),
                        SizedBox(height: getProportionateScreenHeight(15)),
                        CustomFilledTextField(
                          height: SizeConfig.screenHeight / 8,
                          hint: trans(context, 'address'),
                          controller: _addressController,
                        ),
                        SizedBox(height: getProportionateScreenHeight(80)),
                        DefaultButton(
                          text: trans(context, 'update_profile'),
                          press: _updateProfile,
                        ),
                        SizedBox(height: getProportionateScreenHeight(30)),
                      ],
                    )
                  : Container(
                      height: getProportionateScreenHeight(400),
                      child: Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      ),
    );
  }

  _updateProfile() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String password = _passwordController.text;
    String address = _addressController.text;

    if (name.isEmpty && email.isEmpty && phone.isEmpty && password.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(trans(context, 'please_fill_all_required_fields')),
        ),
      );
    } else {
      await loadingDialog(context).show();

      UserModel user = UserModel();
      user.id = _user.id;
      user.name = name;
      user.email = email;
      user.phone = phone;
      user.password = password;
      user.address = address;
      user.dateJoin = _user.dateJoin;
      user.timeJoin = timeFormat.format(DateTime.now());
      user.universityId = '';
      user.statusCode = '1';
      user.dob = '';
      user.gender = '';
      HttpService().updateProfile(context, user);
    }
  }
}
