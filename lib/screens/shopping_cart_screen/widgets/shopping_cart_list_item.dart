import 'package:flutter/material.dart';
import 'package:ketabook/providers/cart_provider.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/screens/book_details_screen/book_details_screen.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:provider/provider.dart';

class ShoppingCartListItem extends StatefulWidget {
  final Book book;
  final bool editMode;

  const ShoppingCartListItem({Key key, this.book, this.editMode})
      : super(key: key);

  @override
  _ShoppingCartListItemState createState() => _ShoppingCartListItemState();
}

class _ShoppingCartListItemState extends State<ShoppingCartListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: widget.book)),
      ),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.book.name,
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
                          ),
                          Text(
                            '${double.parse(widget.book.priceService) + double.parse(widget.book.deliveryFee)} ${trans(context, 'kd')}',
                            style: Theme.of(context).textTheme.headline6.merge(
                                  TextStyle(
                                    color: Colors.black,
                                    fontSize: getProportionateScreenWidth(15),
                                  ),
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Text(
                        widget.book.descp,
                        style: Theme.of(context).textTheme.headline6.merge(
                              TextStyle(
                                color: Color(0xFF666666),
                                fontSize: getProportionateScreenWidth(14),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, left: 10),
                  child: widget.editMode
                      ? InkWell(
                          radius: 50,
                          borderRadius: BorderRadius.circular(30),
                          onTap: () async {
                            await HttpService()
                                .removeFromCart(widget.book.id)
                                .then((value) async {
                              // await widget.removeBook(widget.book.id);
                              Provider.of<CartProvider>(context, listen: false)
                                  .removeBook(widget.book);
                            });
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.remove_circle_outline)),
                        )
                      : Container(),
                )
              ],
            ),
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
}
