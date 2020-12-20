import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/screens/book_details_screen/book_details_screen.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:provider/provider.dart';

class RecentBooksListItem extends StatelessWidget {
  final Book book;

  const RecentBooksListItem({Key key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppNotifier application = Provider.of<AppNotifier>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(right: getProportionateScreenWidth(8)),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookDetailsScreen(book: book))),
        child: Container(
          width: SizeConfig.screenWidth / 3.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 2),
                width: SizeConfig.screenWidth / 4,
                height: getProportionateScreenHeight(150),
                child: Card(
                  margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                  elevation: 4,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenWidth / 50),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: '${WebService.getImageUrl()}${book.photo}',
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(2)),
              Text(
                book.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(15),
                      ),
                    ),
              ),
              Text(
                '${(double.parse(book.priceService) + double.parse(application.getDeliveryFee().first.fee))} ${trans(context, 'kd')}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        color: kPrimaryColor,
                        fontSize: getProportionateScreenWidth(15),
                      ),
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
