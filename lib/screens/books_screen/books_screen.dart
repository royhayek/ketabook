import 'package:flutter/material.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/providers/cart_provider.dart';
import 'package:ketabook/providers/data_provider.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/models/college.dart';
import 'package:ketabook/models/speciality.dart';
import 'package:ketabook/screens/shopping_cart_screen/shopping_cart_screen.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/book_list_item.dart';
import 'package:ketabook/size_config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math' as math;

class BooksScreen extends StatefulWidget {
  static String routeName = "/books_screen";

  final String title;
  final bool implyLeading;
  final College college;
  final Speciality major;
  final List<Book> uniBooks;

  const BooksScreen({
    Key key,
    this.title,
    this.implyLeading,
    this.college,
    this.major,
    this.uniBooks,
  }) : super(key: key);

  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  SessionManager prefs = new SessionManager();
  AppNotifier application;
  DataProvider data;
  AuthProvider auth;
  List<Book> books = [];
  bool isRetrieving;
  bool _shouldStopRequests;
  bool waitForNextRequest;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);
    data = Provider.of<DataProvider>(context, listen: false);
    auth = Provider.of<AuthProvider>(context, listen: false);

    isRetrieving = true;

    _fetchData();
  }

  _fetchData() async {
    _shouldStopRequests = false;
    waitForNextRequest = false;
    await getBooks();
    setState(() {
      isRetrieving = false;
    });
  }

  getBooks() async {
    if (_shouldStopRequests) {
      return;
    }
    if (waitForNextRequest) {
      return;
    }
    waitForNextRequest = true;

    switch (widget.title) {
      case "recent_books":
        if (data.allRecentBooks.isNotEmpty) {
          setState(() {
            books = data.allRecentBooks;
          });
        } else
          await data.fetchAllRecentBooks(
              context: context,
              id: auth.user != null
                  ? auth.user != null
                      ? auth.user.id
                      : ''
                  : '');
        setState(() {
          books = data.allRecentBooks;
        });
        break;
      case "books":
        if (data.allRecentBooks.isNotEmpty) {
          setState(() {
            books = data.allRecentBooks;
          });
        } else
          await data.fetchAllRecentBooks(
              context: context,
              id: auth.user != null
                  ? auth.user != null
                      ? auth.user.id
                      : ''
                  : '');
        setState(() {
          books = data.allRecentBooks;
        });
        break;
      case "university_books":
        setState(() {
          books = widget.uniBooks;
        });
        break;
      default:
        await HttpService()
            .getBooksBySpeciality(context, widget.major.id)
            .then((book) {
          setState(() {
            book.forEach((b) {
              setState(() {
                books.add(b);
              });
            });
          });
        });
        break;
    }
  }

  void _onRefresh() async {
    setState(() {
      isRetrieving = true;
    });

    data.clearAllRecentBooks();
    books = [];
    _shouldStopRequests = false;
    waitForNextRequest = false;
    await getBooks();
    _refreshController.refreshCompleted();
    isRetrieving = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.implyLeading,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: isEnglish(context)
                    ? ImageIcon(AssetImage('assets/images/ic_cart.png'))
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child:
                            ImageIcon(AssetImage('assets/images/ic_cart.png'))),
                onPressed: () =>
                    Navigator.pushNamed(context, ShoppingCartScreen.routeName),
              ),
              Consumer<CartProvider>(
                builder: (context, model, child) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth / 16,
                      vertical: SizeConfig.screenHeight / 145,
                    ),
                    child: model.getUserCartBooks().length != 0
                        ? Align(
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              backgroundColor: Color(0xFFFF3B30),
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    1.0,
                                  ),
                                  child: Text(
                                    model.getUserCartBooks().length.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.screenWidth / 35,
                                    ),
                                  ),
                                ),
                              ),
                              radius: SizeConfig.screenWidth / 50,
                            ),
                          )
                        : Container(),
                  );
                },
              )
            ],
          )
        ],
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trans(context, widget.title) != null
                  ? trans(context, widget.title)
                  : isEnglish(context)
                      ? widget.major != null
                          ? widget.major.nameEn
                          : widget.college.nameEn
                      : widget.major != null
                          ? widget.major.nameAr
                          : widget.college.nameAr,
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(30),
                    ),
                  ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            !isRetrieving
                ? Expanded(
                    child: swipeToRefresh(
                      context,
                      onRefresh: _onRefresh,
                      refreshController: _refreshController,
                      child: books.isNotEmpty
                          ? ListView.builder(
                              cacheExtent: 9999,
                              itemCount: books.length,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return BookListItem(
                                  book: books[index],
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                trans(context, 'no_books_found'),
                                style:
                                    Theme.of(context).textTheme.headline6.merge(
                                          TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                          ),
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
