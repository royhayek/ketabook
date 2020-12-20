import 'package:flutter/material.dart';
import 'package:ketabook/screens/login_screen/login_screen.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/default_button.dart';

class OnBoardScreen extends StatefulWidget {
  static String routeName = "/on_board_screen";

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  List<String> images = [
    "assets/images/onboard1.jpg",
    "assets/images/onboard2.jpg",
    "assets/images/onboard3.jpg",
  ];

  List<String> titles = [];
  List<String> descriptions = [];
  int index = 0;

  Future<bool> _willPopCallback() async {
    if (index >= 1) {
      setState(() {
        index--;
      });
      return false;
    } else
      return true; // return true if the route to be popped
  }

  _addOnBoardDetails(BuildContext context) {
    titles.add(trans(context, 'discover_books_you_need'));
    titles.add(trans(context, 'from_the_best_seller'));
    titles.add(trans(context, 'books_delivered_to_you'));

    descriptions.add(trans(context, 'find_millions_of_books'));
    descriptions.add(trans(context, 'only_the_best_and_selected_sellers'));
    descriptions.add(trans(context, 'enjoy_your_books_casually_wherever'));
  }

  @override
  Widget build(BuildContext context) {
    _addOnBoardDetails(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            images[index],
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/onboardbg.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          WillPopScope(
            onWillPop: _willPopCallback,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                brightness: Brightness.dark,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: getProportionateScreenWidth(16),
                      top: getProportionateScreenHeight(10),
                      left: getProportionateScreenWidth(16),
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName),
                      child: Text(
                        trans(context, 'skip'),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SfProText',
                          fontSize: getProportionateScreenWidth(17),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: getProportionateScreenHeight(80)),
                    Text(
                      'Bookstora',
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              fontSize: getProportionateScreenWidth(25),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(80)),
                    Text(
                      titles[index],
                      maxLines: 2,
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              fontSize: getProportionateScreenWidth(40),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Text(
                      descriptions[index],
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              fontSize: getProportionateScreenWidth(17),
                            ),
                          ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(78)),
                    Row(
                      children: [
                        Text(
                          '0${index + 1}',
                          style: Theme.of(context).textTheme.headline6.merge(
                                TextStyle(
                                  fontSize: getProportionateScreenWidth(15),
                                ),
                              ),
                        ),
                        Text(
                          ' / 0${images.length}',
                          style: Theme.of(context).textTheme.headline6.merge(
                                TextStyle(
                                  fontSize: getProportionateScreenWidth(15),
                                  color: Color(0xFF8A8A8F),
                                ),
                              ),
                        ),
                      ],
                    ),
                    Spacer(),
                    DefaultButton(
                      text: index < images.length - 1
                          ? trans(context, 'next')
                          : 'Get Started',
                      press: () {
                        setState(() {
                          if (index < images.length - 1)
                            index++;
                          else
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.routeName);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
