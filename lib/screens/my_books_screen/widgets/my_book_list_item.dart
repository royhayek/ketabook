import 'package:flutter/material.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/providers/data_provider.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/screens/book_details_screen/book_details_screen.dart';
import 'package:ketabook/screens/edit_book_screen/edit_book_screen.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:provider/provider.dart';

class MyBookListItem extends StatelessWidget {
  final Book book;
  final Function getbooks;

  const MyBookListItem({Key key, this.book, this.getbooks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookDetailsScreen(book: book)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      book.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.screenWidth / 21,
                            ),
                          ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(5)),
                    Text(
                      book.descp,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              color: Color(0xFF666666),
                              fontSize: SizeConfig.screenWidth / 25,
                            ),
                          ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(5)),
                    Text(
                      '${book.price} ${trans(context, 'kd')}',
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              color: kPrimaryColor,
                              fontSize: SizeConfig.screenWidth / 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    radius: 50,
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBookScreen(book: book),
                        ),
                      ).then((value) {
                        getbooks();
                      });
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(Icons.build_circle_outlined)),
                  ),
                  InkWell(
                    radius: 50,
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      _bookDeletionConfDialog(context);
                    },
                    // onTap: () => Navigator.pushNamed(
                    //     context, CartScreen.routeName),
                    child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(Icons.remove_circle_outline)),
                  ),
                ],
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

  _bookDeletionConfDialog(BuildContext context) {
    var data = Provider.of<DataProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          trans(context, 'are_you_sure_you_want_to_delete_this_book'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17, color: Colors.black),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  await HttpService().removebook(book);
                  getbooks();
                  data.clearAllRecentBooks();
                  data.fetchAllRecentBooks(
                    context: context,
                    id: Provider.of<AuthProvider>(context, listen: false)
                        .user
                        .id,
                  );
                  data.clearLimitedRecentBooks();
                  data.fetchLimitedRecentBooks(
                    context: context,
                    id: Provider.of<AuthProvider>(context, listen: false)
                        .user
                        .id,
                  );
                  Navigator.pop(context);
                },
                color: kPrimaryColor,
                child: Text(trans(context, 'yes'),
                    style: TextStyle(color: Colors.white)),
              ),
              RaisedButton(
                onPressed: () => Navigator.pop(context),
                color: kPrimaryColor,
                child: Text(trans(context, 'no'),
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
