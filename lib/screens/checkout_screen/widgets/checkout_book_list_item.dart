import 'package:flutter/material.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/screens/book_details_screen/book_details_screen.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';

class CheckoutBookListItem extends StatelessWidget {
  final Book book;

  const CheckoutBookListItem({Key key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookDetailsScreen(book: book)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // padding: EdgeInsets.only(bottom: 3),
                    width: getProportionateScreenWidth(80),
                    height: getProportionateScreenHeight(120),
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
                        '${WebService.getImageUrl()}${book.photo}',
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          book.name,
                          style: Theme.of(context).textTheme.headline6.merge(
                                TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(16),
                                ),
                              ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        Text(
                          book.descp,
                          style: Theme.of(context).textTheme.headline6.merge(
                                TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: getProportionateScreenWidth(14),
                                ),
                              ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        Text(
                          '${double.parse(book.priceService) + double.parse(book.deliveryFee)} ${trans(context, 'kd')}',
                          style: Theme.of(context).textTheme.headline6.merge(
                                TextStyle(
                                  color: Colors.black,
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
            SizedBox(height: getProportionateScreenHeight(5)),
            Divider(
              height: 0,
              thickness: 1,
              indent: getProportionateScreenWidth(82),
              color: Color(0xFFEFEFF4),
            ),
          ],
        ),
      ),
    );
  }
}
