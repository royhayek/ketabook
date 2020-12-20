import 'package:flutter/material.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/providers/cart_provider.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/models/cart.dart';
import 'package:ketabook/screens/checkout_screen/checkout_screen.dart';
import 'package:ketabook/screens/login_screen/login_screen.dart';
import 'package:ketabook/screens/shopping_cart_screen/widgets/shopping_cart_list_item.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/default_button.dart';
import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatefulWidget {
  static String routeName = "/shopping_cart_screen";

  const ShoppingCartScreen({Key key}) : super(key: key);

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  AppNotifier application;
  CartProvider cart;
  SessionManager prefs = SessionManager();
  List<Book> cartBooks = [];
  List<Cart> carts = [];
  double totalPrice = 0.0;
  bool editMode = false;
  bool isRetrieving = true;
  String cartId;

  @override
  void initState() {
    super.initState();

    application = Provider.of<AppNotifier>(context, listen: false);
    cart = Provider.of<CartProvider>(context, listen: false);

    prefs.getUserId().then((id) {
      if (id != null)
        _getCart();
      else {
        showNeedLoginDialog(
          context,
          trans(context, 'sorry_you_need_to_login_to_see_your_shopping_cart'),
          () => Navigator.popUntil(
            context,
            ModalRoute.withName(LoginScreen.routeName),
          ),
          () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
        setState(() {
          isRetrieving = false;
        });
      }
    });
  }

  _getCart() async {
    carts.clear();
    cartBooks.clear();
    totalPrice = 0.0;

    setState(() {
      isRetrieving = true;
    });

    if (cart.cartBooks.isEmpty && cart.carts.isEmpty) {
      print('we are here');
      setState(() {
        isRetrieving = false;
      });
    } else if (cart.getUserCartBooks().isNotEmpty &&
        cart.getUserCart().isNotEmpty) {
      setState(() {
        carts = cart.getUserCart();
      });

      cart.getUserCartBooks().forEach((b) {
        totalPrice += (double.parse(b.priceService) +
            double.parse(application.getDeliveryFee().first.fee));
        print(totalPrice);
        cart.setCartTotalPrice(totalPrice);
      });
      setState(() {
        cartBooks = cart.getUserCartBooks();
      });

      setState(() {
        isRetrieving = false;
      });
    } else {
      await HttpService().getCart().then((c) {
        setState(() {
          carts = c;
          cart.setUserCart(c);
        });
        c.forEach((c) async {
          totalPrice += double.parse(c.priceService);
          cart.setCartTotalPrice(totalPrice);
          await HttpService().getBook(c.bookId).then((book) async {
            cartBooks.add(book);
            cart.setUserCartBooks(cartBooks);
            cartId = c.id;
            setState(() {});
          }).whenComplete(() {
            setState(() {
              isRetrieving = false;
            });
          });
        });
      });
    }

    setState(() {
      isRetrieving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: SizeConfig.screenWidth / 6.5,
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  editMode = !editMode;
                });
              },
              child: Text(
                editMode ? trans(context, 'cancel') : trans(context, 'edit'),
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        color: Color(0xFF666666),
                        fontSize: SizeConfig.screenWidth / 21,
                      ),
                    ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
            ),
            child: Text(
              trans(context, 'shopping_cart'),
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(30),
                    ),
                  ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(2)),
          Divider(
            height: 10,
            thickness: 1,
            color: Color(0xFFEFEFF4),
          ),
          Expanded(
              child: isRetrieving
                  ? Center(child: CircularProgressIndicator())
                  : Consumer<CartProvider>(
                      builder: (context, value, child) {
                        if (value.cartBooks.isNotEmpty)
                          return ListView.builder(
                            itemCount: value.cartBooks.length,
                            padding: EdgeInsets.only(
                              left: getProportionateScreenWidth(16),
                              top: getProportionateScreenHeight(10),
                            ),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ShoppingCartListItem(
                                book: value.cartBooks[index],
                                editMode: editMode,
                              );
                            },
                          );
                        else
                          return Center(
                            child: Text(
                              trans(context, 'your_shopping_cart_is_empty'),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .merge(
                                    TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: getProportionateScreenWidth(18),
                                    ),
                                  ),
                            ),
                          );
                      },
                    )),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getProportionateScreenHeight(5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trans(context, 'total_price'),
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(17),
                            ),
                          ),
                    ),
                    Consumer<CartProvider>(
                      builder: (context, value, child) => Text(
                        '${value.getCartTotalPrice()} ${trans(context, 'kd')}',
                        style: Theme.of(context).textTheme.headline6.merge(
                              TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(17),
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                Consumer<CartProvider>(
                  builder: (context, value, child) => Text(
                    convertUnit(context, value.getUserCartBooks().length),
                    style: Theme.of(context).textTheme.headline6.merge(
                          TextStyle(
                            color: Color(0xFF666666),
                            fontSize: getProportionateScreenWidth(13),
                          ),
                        ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                DefaultButton(
                  press: () async {
                    var cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    if (cartProvider.cartBooks.isNotEmpty)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            books: cartProvider.cartBooks,
                            totalPrice: Provider.of<CartProvider>(context,
                                    listen: false)
                                .getCartTotalPrice(),
                            cart: carts,
                            getCart: _getCart,
                          ),
                        ),
                      );
                  },
                  text: trans(context, 'checkout'),
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
