import 'package:flutter/material.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/screens/book_details_screen/book_details_screen.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';

class UniversityBookListItem extends StatelessWidget {
  final Book book;

  const UniversityBookListItem({Key key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookDetailsScreen(book: book),
        ),
      ),
      child: Container(
        width: getProportionateScreenWidth(105),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10),
              width: getProportionateScreenWidth(105),
              height: getProportionateScreenHeight(180),
              child: Card(
                margin: EdgeInsets.only(right: 8),
                elevation: 5,
                color: Color(0xFFC8C7CC),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  '${WebService.getImageUrl()}${book.photo}',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              book.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: getProportionateScreenWidth(13),
                    ),
                  ),
            ),
            Text(
              '${double.parse(book.priceService) + double.parse(book.deliveryFee)} ${trans(context, 'kd')}',
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w400,
                      fontSize: getProportionateScreenWidth(13),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
