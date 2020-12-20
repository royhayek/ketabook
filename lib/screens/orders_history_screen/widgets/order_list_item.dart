import 'package:flutter/material.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/models/order.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';

class OrderListItem extends StatelessWidget {
  final Order order;

  const OrderListItem({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => null,
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // padding: EdgeInsets.only(bottom: 3),
                  width: SizeConfig.screenWidth / 5,
                  height: SizeConfig.screenHeight / 7,
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
                      '${WebService.getImageUrl()}${order.bookImage}',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: isEnglish(context)
                            ? EdgeInsets.only(
                                right: getProportionateScreenWidth(16),
                              )
                            : EdgeInsets.only(
                                left: getProportionateScreenWidth(16),
                              ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${trans(context, 'order')} # ${order.orderCode}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .merge(
                                    TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(16),
                                    ),
                                  ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: orderColor(order.statusCode),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                '${orderStatus(context, order.statusCode)}',
                                style:
                                    Theme.of(context).textTheme.headline6.merge(
                                          TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(13),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Text(
                        '${order.dateOrder} - ${order.timeOrder.substring(0, 5)}',
                        style: Theme.of(context).textTheme.headline6.merge(
                              TextStyle(
                                color: Color(0xFF666666),
                                fontSize: getProportionateScreenWidth(14),
                              ),
                            ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Text(
                        '${order.totalPrice} ${trans(context, 'kd')}',
                        style: Theme.of(context).textTheme.headline6.merge(
                              TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: getProportionateScreenWidth(15),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(2)),
        Divider(height: 10, thickness: 1),
      ],
    );
  }
}

Color orderColor(String code) {
  switch (code) {
    case '1':
      return Colors.red;
      break;
    case '2':
      return Colors.yellow;
      break;
    case '3':
      return Colors.green;
      break;
  }
  return Colors.green;
}

String orderStatus(BuildContext context, String code) {
  switch (code) {
    case '1':
      return trans(context, 'waiting_confirmation');
      break;
    case '2':
      return trans(context, 'processing');
      break;
    case '3':
      return trans(context, 'completed');
      break;
  }
  return null;
}
