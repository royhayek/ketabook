import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/models/page_desc.dart';
import 'package:ketabook/screens/information_screen/widgets/contact_list_item.dart';
import 'package:ketabook/screens/tabs_screen/tabs_screen.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/default_button.dart';
import 'package:provider/provider.dart';

class InformationScreen extends StatefulWidget {
  static String routeName = "/information_screen";

  final String title;

  const InformationScreen({Key key, this.title}) : super(key: key);

  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  AppNotifier application;
  bool contactUsEnabled = false;
  bool successMessageEnabled = false;
  PageDesc pageDesc;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);

    switch (widget.title) {
      case 'contact_us':
        contactUsEnabled = true;
        break;
      case 'Success':
        successMessageEnabled = true;
        break;
      case 'about_us':
        pageDesc = application.getPageDesc()[2];
        break;
      case 'terms_of_use':
        pageDesc = application.getPageDesc()[3];
        break;
      case 'faq':
        pageDesc = application.getPageDesc()[4];
        break;
      default:
        contactUsEnabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: successMessageEnabled ? false : true,
        backgroundColor:
            successMessageEnabled ? Colors.transparent : Colors.white,
      ),
      backgroundColor: successMessageEnabled ? Color(0xFFEFEFF4) : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(16),
          ),
          child: !successMessageEnabled
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trans(context, widget.title),
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(30),
                            ),
                          ),
                    ),
                    SizedBox(
                        height: contactUsEnabled
                            ? getProportionateScreenHeight(20)
                            : 0),
                    contactUsEnabled
                        ? Column(
                            children: [
                              SizedBox(
                                  height: getProportionateScreenHeight(40)),
                              ContactListItem(
                                title: trans(context, 'phone'),
                                icon: Icon(Icons.phone_android),
                                value: '+965-66016647',
                              ),
                              Divider(
                                  height: getProportionateScreenHeight(30),
                                  thickness: 1,
                                  color: Color(0xFFEFEFF4)),
                              ContactListItem(
                                title: trans(context, 'email_address'),
                                icon: Icon(Icons.email),
                                value: 'info@ketabook-kw.com',
                              ),
                            ],
                          )
                        : Html(
                            data: isEnglish(context)
                                ? pageDesc.contentEn
                                : pageDesc.contentAr,
                            onLinkTap: (url) {
                              print("Opening $url...");
                            },
                            onImageTap: (src) {
                              print(src);
                            },
                            onImageError: (exception, stackTrace) {
                              print(exception);
                            },
                            style: {
                              "p": Style(
                                fontSize: FontSize(SizeConfig.screenWidth / 20),
                              ),
                            },
                          ),
                    // Text(
                    //     isEnglish(context)
                    //         ? termsOfUse.contentEn
                    //         : termsOfUse.contentAr,
                    //     style: Theme.of(context).textTheme.headline6.merge(
                    //           TextStyle(
                    //             color: Colors.black,
                    //             fontSize: getProportionateScreenWidth(15),
                    //             height: 2,
                    //           ),
                    //         ),
                    //   ),
                  ],
                )
              : Column(
                  children: [
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: getProportionateScreenHeight(550),
                        child: Card(
                          shadowColor: Color(0x40707070),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.screenWidth / 50),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: getProportionateScreenHeight(45)),
                              Text(
                                trans(context, 'success'),
                                style:
                                    Theme.of(context).textTheme.headline6.merge(
                                          TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(38),
                                          ),
                                        ),
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(45)),
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 55,
                                child:
                                    Image.asset('assets/images/ic_success.png'),
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(58)),
                              Text(
                                trans(context, 'thank_you_for_shopping'),
                                style:
                                    Theme.of(context).textTheme.headline6.merge(
                                          TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(22),
                                          ),
                                        ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(45),
                                ),
                                child: Text(
                                  trans(context, 'your_items_has_been_placed'),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .merge(
                                        TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize:
                                              getProportionateScreenWidth(15),
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(15)),
                    DefaultButton(
                      text: trans(context, 'back_to_shop'),
                      press: () => Navigator.popAndPushNamed(
                        context,
                        TabsScreen.routeName,
                      ),
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      borderColor: kPrimaryColor,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
