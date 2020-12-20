import 'package:flutter/material.dart';
import 'package:ketabook/models/order.dart';
import 'package:ketabook/screens/orders_history_screen/widgets/order_list_item.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';

class OrdersHistoryScreen extends StatefulWidget {
  static String routeName = "/orders_history_screen";

  const OrdersHistoryScreen({Key key}) : super(key: key);

  @override
  _OrdersHistoryScreenState createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  SessionManager prefs = SessionManager();
  List<Order> orders = [];
  bool isRetrieving = true;

  @override
  void initState() {
    super.initState();

    prefs.getUserId().then((id) async {
      await HttpService().getOrders(id).then((o) {
        setState(() {
          orders = o;
        });
      }).whenComplete(() {
        setState(() {
          isRetrieving = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
            ),
            child: Text(
              trans(context, 'order_history'),
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(30),
                    ),
                  ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          !isRetrieving
              ? Expanded(
                  child: orders.isNotEmpty
                      ? ListView.builder(
                          padding: isEnglish(context)
                              ? EdgeInsets.only(
                                  left: getProportionateScreenWidth(16))
                              : EdgeInsets.only(
                                  right: getProportionateScreenWidth(16)),
                          shrinkWrap: true,
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return OrderListItem(order: orders[index]);
                          },
                        )
                      : Center(
                          child: Text(
                            trans(context, 'you_havent_ordered_any_book'),
                            style: Theme.of(context).textTheme.headline6.merge(
                                  TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: getProportionateScreenWidth(18),
                                  ),
                                ),
                          ),
                        ),
                )
              : Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ],
      ),
    );
  }
}
