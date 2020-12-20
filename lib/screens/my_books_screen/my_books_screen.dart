import 'package:flutter/material.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/screens/my_books_screen/widgets/my_book_list_item.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/size_config.dart';

class MyBooksScreen extends StatefulWidget {
  static String routeName = "/my_books_screen";

  final String title;
  final bool implyLeading;

  const MyBooksScreen({Key key, this.title, this.implyLeading})
      : super(key: key);

  @override
  _MyBooksScreenState createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  SessionManager session = SessionManager();
  List<Book> myBooks = [];
  bool isRetrieving = true;

  @override
  void initState() {
    super.initState();

    getBooks();
  }

  getBooks() {
    session.getUserId().then((userId) async {
      await HttpService().getBooksByUser(context, userId).then((books) {
        setState(() {
          myBooks = books;
        });
      });
    }).whenComplete(() {
      setState(() {
        isRetrieving = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trans(context, 'my_books'),
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(30),
                    ),
                  ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            !isRetrieving
                ? myBooks.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: myBooks.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return MyBookListItem(
                              book: myBooks[index],
                              getbooks: getBooks,
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Text(
                            trans(context, 'you_havent_added_any_book'),
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
      ),
    );
  }
}
