import 'package:flutter/material.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/providers/cart_provider.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/screens/book_details_screen/book_details_screen.dart';
import 'package:ketabook/screens/login_screen/login_screen.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class BookListItem extends StatefulWidget {
  final Book book;

  const BookListItem({
    Key key,
    this.book,
  }) : super(key: key);

  @override
  _BookListItemState createState() => _BookListItemState();
}

class _BookListItemState extends State<BookListItem> {
  List<Book> books = [];
  AppNotifier application;
  bool alreadyExist = false;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: widget.book)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // padding: EdgeInsets.only(bottom: 3),
                width: SizeConfig.screenWidth / 4.5,
                height: SizeConfig.screenHeight / 6,
                child: Card(
                  margin: EdgeInsets.all(0),
                  elevation: 5,
                  color: Color(0xFFC8C7CC),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenWidth / 50),
                  ),
                  child: Image.network(
                    '${WebService.getImageUrl()}${widget.book.photo}',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.book.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.screenWidth / 21,
                            ),
                          ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(6)),
                    Text(
                      widget.book.descp,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              color: Color(0xFF666666),
                              fontSize: SizeConfig.screenWidth / 25,
                            ),
                          ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(6)),
                    Text(
                      '${(double.parse(widget.book.priceService) + double.parse(application.getDeliveryFee().first.fee))} ${trans(context, 'kd')}',
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              color: kPrimaryColor,
                              fontSize: SizeConfig.screenWidth / 25,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              auth.user != null
                  ? auth.user.id != widget.book.userId
                      ? InkWell(
                          radius: 50,
                          borderRadius: BorderRadius.circular(30),
                          onTap: !_isAddingToCart ? _addToCart : () => null,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: !_isAddingToCart
                                ? isEnglish(context)
                                    ? Image.asset(
                                        'assets/images/ic_add_to_cart.png',
                                        width: SizeConfig.screenWidth / 15,
                                      )
                                    : Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(math.pi),
                                        child: Image.asset(
                                          'assets/images/ic_add_to_cart.png',
                                          width: SizeConfig.screenWidth / 15,
                                        ),
                                      )
                                : SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      backgroundColor: Colors.white,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black),
                                    ),
                                  ),
                          ),
                        )
                      : Container()
                  : InkWell(
                      radius: 50,
                      borderRadius: BorderRadius.circular(30),
                      onTap: !_isAddingToCart ? _addToCart : () => null,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: !_isAddingToCart
                            ? isEnglish(context)
                                ? Image.asset(
                                    'assets/images/ic_add_to_cart.png',
                                    width: SizeConfig.screenWidth / 15,
                                  )
                                : Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: Image.asset(
                                      'assets/images/ic_add_to_cart.png',
                                      width: SizeConfig.screenWidth / 15,
                                    ),
                                  )
                            : SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              ),
                      ),
                    ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(5)),
          Divider(
            height: 10,
            thickness: 1,
            indent: getProportionateScreenWidth(90),
            color: Color(0xFFEFEFF4),
          ),
        ],
      ),
    );
  }

  _addToCart() async {
    var cart = Provider.of<CartProvider>(context, listen: false);
    setState(() {
      _isAddingToCart = true;
    });
    SessionManager prefs = SessionManager();
    await prefs.getUserId().then((id) async {
      if (id != null) {
        if (cart.getUserCartBooks().any((b) => b.id == widget.book.id)) {
          Toast.show(trans(context, 'book_already_exist'), context);
        } else {
          await HttpService().addToCart(context, widget.book, id);
          cart.addBookToCart(widget.book);
        }
      } else
        Navigator.popUntil(context, ModalRoute.withName(LoginScreen.routeName));
    });
    setState(() {
      _isAddingToCart = false;
    });
  }
}
