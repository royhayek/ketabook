import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/providers/cart_provider.dart';
import 'package:ketabook/providers/data_provider.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/models/cart.dart';
import 'package:ketabook/models/delivery_fee.dart';
import 'package:ketabook/models/delivery_time.dart';
import 'package:ketabook/models/order_object.dart';
import 'package:ketabook/screens/checkout_screen/widgets/checkout_book_list_item.dart';
import 'package:ketabook/screens/information_screen/information_screen.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/default_button.dart';
import 'package:ketabook/widgets/progress_dialog.dart';
import 'package:ketabook/widgets/terms_of_use_checkbox.dart';
import 'package:ketabook/widgets/custom_filled_text_field.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckoutScreen extends StatefulWidget {
  static String routeName = "/checkout_screen";

  final List<Book> books;
  final List<Cart> cart;
  final double totalPrice;
  final Function getCart;

  const CheckoutScreen({
    Key key,
    this.books,
    this.totalPrice,
    this.cart,
    this.getCart,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _selectTimeController = TextEditingController();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateFormat timeFormat = DateFormat('kk:mm:ss');
  AppNotifier application;
  AuthProvider auth;
  DataProvider data;
  CartProvider cart;
  List<DeliveryTime> deliveryTime = [];
  List<DeliveryFee> deliveryFee = [];
  String selectedRadio;

  bool agree = false;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);
    auth = Provider.of<AuthProvider>(context, listen: false);
    data = Provider.of<DataProvider>(context, listen: false);
    cart = Provider.of<CartProvider>(context, listen: false);

    deliveryTime = application.getDeliveryTime();
    deliveryFee = application.getDeliveryFee();

    _getInfo();

    _selectTimeController.text = isEnglish(context)
        ? deliveryTime.first.deliveryTimeEn
        : deliveryTime.first.deliveryTimeAr;
  }

  _getInfo() async {
    await HttpService().getOrderStatus().then((status) async {
      if (status != '1') {
        showCustomDialog(context, trans(context, 'order_disabled'),
            Icon(Icons.close, size: 50, color: Colors.red), () {
          Navigator.pop(context);
        });
      }
    });

    HttpService().getUserInfo().then((user) {
      setState(() {
        _nameController.text = user.name;
        _phoneController.text = user.phone;
        _addressController.text = user.address;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(16),
              ),
              child: Text(
                trans(context, 'checkout'),
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(30),
                      ),
                    ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(16),
                top: getProportionateScreenHeight(10),
              ),
              shrinkWrap: true,
              itemCount: widget.books.length,
              itemBuilder: (context, index) {
                return CheckoutBookListItem(book: widget.books[index]);
              },
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getProportionateScreenHeight(5)),
                  Text(
                    trans(context, 'please_fill_all_information'),
                    style: Theme.of(context).textTheme.headline6.merge(
                          TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                          ),
                        ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(12)),
                  CustomFilledTextField(
                    height: SizeConfig.screenHeight / 16,
                    hint: trans(context, 'name'),
                    controller: _nameController,
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
                    hint: trans(context, 'address'),
                    controller: _addressController,
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  InkWell(
                    onTap: showDeliveryTimeDialog,
                    child: CustomFilledTextField(
                      height: SizeConfig.screenHeight / 16,
                      hint:
                          '${trans(context, 'from')} 3 ${trans(context, 'till')} 11 pm',
                      enabled: false,
                      controller: _selectTimeController,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(12)),
                  TermsOfUseCheckbox(
                    agree: agree,
                    onTap: () {
                      setState(() {
                        agree = !agree;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // priceSummaryRow(trans(context, 'book_price'),
                  //     application.totalCartPrice.toString()),
                  // priceSummaryRow(trans(context, 'delivery_fee'),
                  //     application.getDeliveryFee().first.fee),
                  priceSummaryRow(trans(context, 'total_price'),
                      cart.totalCartPrice.toString()),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  DefaultButton(
                    text: trans(context, 'checkout'),
                    total: '${cart.totalCartPrice} ${trans(context, 'kd')}',
                    press: () {
                      placeOrder();
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showDeliveryTimeDialog() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext ctx, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(trans(context, 'choose_the_delivery_time')),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: List<Widget>.generate(deliveryTime.length,
                          (int index) {
                        return RadioListTile<String>(
                          title: Text(isEnglish(context)
                              ? deliveryTime[index].deliveryTimeEn
                              : deliveryTime[index].deliveryTimeAr),
                          value: isEnglish(context)
                              ? deliveryTime[index].deliveryTimeEn
                              : deliveryTime[index].deliveryTimeAr,
                          groupValue: selectedRadio,
                          selected: false,
                          onChanged: (String value) {
                            Navigator.pop(context);
                            setState(() {
                              selectedRadio = value;
                              _selectTimeController.text = selectedRadio;
                            });
                          },
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  Widget priceSummaryRow(String text, String price) {
    return Padding(
      padding: EdgeInsets.only(top: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(16),
                  ),
                ),
          ),
          Text(
            '$price ${trans(context, 'kd')}',
            style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(16),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  placeOrder() async {
    SessionManager prefs = SessionManager();
    String userId;
    await prefs.getUserId().then((id) {
      setState(() {
        userId = id;
      });
    });

    if (agree) {
      Fluttertoast.showToast(
          msg: trans(context, 'you_need_to_agree_to_terms_of_use'),
          fontSize: getProportionateScreenWidth(14));
      return;
    }

    if (_nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _selectTimeController.text.isNotEmpty) {
      await loadingDialog(context).show();

      // OrderObject orderObject = new OrderObject();
      // orderObject.userId = userId;
      // orderObject.bookOwner = widget.cart.first.id;
      // orderObject.name = _nameController.text;
      // orderObject.phone = _phoneController.text;
      // orderObject.address = _addressController.text;
      // orderObject.selectTime = _selectTimeController.text;
      // orderObject.deliveryFee = deliveryFee.first.fee;
      // orderObject.totalPrice = widget.totalPrice.toString();
      // orderObject.dateOrder = dateFormat.format(DateTime.now());
      // orderObject.timeOrder = timeFormat.format(DateTime.now());
      // orderObject.statusCode = '1';

      // await HttpService().getOrderStatus().then((status) async {
      //   if (status == '1') {
      //     await HttpService()
      //         .placeOrder(context, _scaffoldKey, orderObject)
      //         .then((orderId) {
      //       print(orderId);
      //       widget.cart.forEach((c) async {
      //         OrderCarts cart = new OrderCarts();
      //         cart.orderId = orderId;
      //         print('orderId: $orderId');
      //         print('bookID: ${c.bookId}');
      //         cart.bookId = c.bookId;

      //         FocusScope.of(context).requestFocus(FocusNode());
      //         await HttpService().placeOrderCarts(context, _scaffoldKey, cart);
      //         widget.getCart();
      //         application.clearAllRecentBooks();

      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => InformationScreen(
      //               title: 'Success',
      //             ),
      //           ),
      //         );
      //       });
      //     });

      await HttpService().getOrderStatus().then((status) async {
        if (status == '1') {
          cart.cartBooks.forEach((b) async {
            OrderObject orderObject = new OrderObject();
            orderObject.userId = userId;
            orderObject.bookOwner = b.userId;
            orderObject.name = _nameController.text;
            orderObject.phone = _phoneController.text;
            orderObject.address = _addressController.text;
            orderObject.selectTime = _selectTimeController.text;
            orderObject.deliveryFee = deliveryFee.first.fee;
            orderObject.totalPrice = (double.parse(b.priceService) +
                    double.parse(deliveryFee.first.fee))
                .toString();
            orderObject.dateOrder = dateFormat.format(DateTime.now());
            orderObject.timeOrder = timeFormat.format(DateTime.now());
            orderObject.bookImage = b.photo;
            orderObject.statusCode = '1';

            Cart cartObject = new Cart();
            cartObject.bookId = b.id;
            cartObject.ownerId = b.userId;
            cartObject.quantity = '1';
            cartObject.price = b.price;
            cartObject.serviceFee = b.serviceFee;
            cartObject.priceService = b.priceService;

            // OrderCarts cart = new OrderCarts();
            // cart.orderId = orderId;
            // print('orderId: $orderId');
            // print('bookID: ${c.bookId}');
            // cart.bookId = c.bookId;

            await HttpService().placeOrder(context, orderObject, cartObject);
          });

          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
            trans(context, 'cart_add_successfully'),
          )));
          await loadingDialog(context).hide();
          FocusScope.of(context).requestFocus(FocusNode());
          // await HttpService().placeOrderCarts(context, _scaffoldKey, cart);
          await widget.getCart();
          await cart.clearUserCart();
          data.clearAllRecentBooks();
          data.fetchAllRecentBooks(
            context: context,
            id: Provider.of<AuthProvider>(context, listen: false).user.id,
          );
          data.clearLimitedRecentBooks();
          data.fetchLimitedRecentBooks(
            context: context,
            id: Provider.of<AuthProvider>(context, listen: false).user.id,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => InformationScreen(
                title: 'Success',
              ),
            ),
          );
        } else {
          showCustomDialog(context, trans(context, 'order_disabled'),
              Icon(Icons.close, size: 50, color: Colors.red), () async {
            Navigator.pop(context);
            await loadingDialog(context).hide();
          });
        }
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
        trans(context, 'please_fill_all_information'),
      )));
    }
  }
}
