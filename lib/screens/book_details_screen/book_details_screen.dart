import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/providers/cart_provider.dart';
import 'package:ketabook/providers/data_provider.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/models/photo.dart';
import 'package:ketabook/screens/book_details_screen/widgets/book_image_list_item.dart';
import 'package:ketabook/screens/book_details_screen/widgets/university_book_list_item.dart';
import 'package:ketabook/screens/books_screen/books_screen.dart';
import 'package:ketabook/screens/login_screen/login_screen.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/default_button.dart';
import 'package:ketabook/widgets/list_view_title.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class BookDetailsScreen extends StatefulWidget {
  static String routeName = "/book_details_screen";

  final Book book;

  const BookDetailsScreen({Key key, this.book}) : super(key: key);

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SessionManager prefs = SessionManager();
  AppNotifier application;
  List<Book> uniBooks = [];
  List<Book> twentyBooks = [];
  List<Photo> images = [];
  List<String> imagesString = [];
  String image, image2, image3, image4;
  bool _showPreview = false;
  String _previewImage;
  bool _isLoading = true;
  bool _isAddtingToCart = false;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);
    var data = Provider.of<DataProvider>(context, listen: false);

    if (data.allRecentBooks.isNotEmpty) {
      data.allRecentBooks.forEach((b) {
        if (b.universityId == widget.book.universityId)
          prefs.getUserId().then((id) {
            if (b.id != widget.book.id) uniBooks.add(b);
          });
      });
    }

    getBookImages();
  }

  getBookImages() async {
    await HttpService().getBookImages(widget.book.id).then((p) {
      images = p;
      for (int i = 0; i < images.length; i++) {
        setState(() {
          if (images[i].photo != widget.book.photo)
            setState(() {
              imagesString.add(images[i].photo);
            });
        });
      }

      setState(() {
        image = widget.book.photo;
        if (imagesString.length > 0) image2 = imagesString[0];
        if (imagesString.length > 1) image3 = imagesString[1];
        if (imagesString.length > 2) image4 = imagesString[2];
      });
    }).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFF9F9F9),
        title: Text(
          trans(context, 'book_details'),
          style: Theme.of(context)
              .appBarTheme
              .textTheme
              .headline5
              .merge(TextStyle(fontSize: SizeConfig.screenWidth / 22)),
        ),
        centerTitle: true,
      ),
      body: !_isLoading
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: isEnglish(context)
                                ? EdgeInsets.only(
                                    left: getProportionateScreenWidth(16))
                                : EdgeInsets.only(
                                    right: getProportionateScreenWidth(16)),
                            child: Container(
                              color: Color(0xFFF9F9F9),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: getProportionateScreenHeight(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () => showImagePreviewDialog(
                                          context, widget.book.photo),
                                      child: Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        width: getProportionateScreenWidth(115),
                                        height:
                                            getProportionateScreenHeight(190),
                                        child: Card(
                                          margin: EdgeInsets.all(2),
                                          elevation: 5,
                                          color: Color(0xFFC8C7CC),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                SizeConfig.screenWidth / 50),
                                          ),
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                '${WebService.getImageUrl()}${widget.book.photo}',
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: getProportionateScreenWidth(20)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            widget.book.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .merge(
                                                  TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            20),
                                                  ),
                                                ),
                                          ),
                                          SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      20)),
                                          Text(
                                            widget.book.statusCode == '1'
                                                ? trans(context, 'available')
                                                : 'Not Available',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .merge(
                                                  TextStyle(
                                                    color: kPrimaryColor,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            15),
                                                  ),
                                                ),
                                          ),
                                          SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      20)),
                                          Text(
                                            '${double.parse(widget.book.priceService) + double.parse(widget.book.deliveryFee)} ${trans(context, 'kd')}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .merge(
                                                  TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            15),
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
                          ),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          Padding(
                            padding: isEnglish(context)
                                ? EdgeInsets.only(
                                    left: getProportionateScreenWidth(16))
                                : EdgeInsets.only(
                                    right: getProportionateScreenWidth(16)),
                            child: Container(
                              height: image2 != null
                                  ? getProportionateScreenHeight(160)
                                  : 0,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  image2 != null
                                      ? BookImageListItem(imageName: image2)
                                      : Container(),
                                  image3 != null
                                      ? BookImageListItem(imageName: image3)
                                      : Container(),
                                  image4 != null
                                      ? BookImageListItem(imageName: image4)
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: isEnglish(context)
                                ? EdgeInsets.only(
                                    left: getProportionateScreenWidth(16))
                                : EdgeInsets.only(
                                    right: getProportionateScreenWidth(16)),
                            child: Text(
                              trans(context, 'description'),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .merge(
                                    TextStyle(
                                        fontSize: SizeConfig.screenWidth / 20),
                                  ),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          Padding(
                            padding: EdgeInsets.only(
                              right: getProportionateScreenWidth(16),
                              left: getProportionateScreenWidth(16),
                            ),
                            child: Text(
                              widget.book.descp,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .merge(
                                    TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: getProportionateScreenWidth(14),
                                    ),
                                  ),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          uniBooks.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: isEnglish(context)
                                          ? EdgeInsets.only(
                                              left: getProportionateScreenWidth(
                                                  16))
                                          : EdgeInsets.only(
                                              right:
                                                  getProportionateScreenWidth(
                                                      16)),
                                      child: ListViewTitle(
                                        title:
                                            trans(context, 'university_books'),
                                        function: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BooksScreen(
                                              title: "university_books",
                                              implyLeading: true,
                                              uniBooks: uniBooks,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(20)),
                                    Padding(
                                      padding: isEnglish(context)
                                          ? EdgeInsets.only(
                                              left: getProportionateScreenWidth(
                                                  16))
                                          : EdgeInsets.only(
                                              right:
                                                  getProportionateScreenWidth(
                                                      16)),
                                      child: Container(
                                        height:
                                            getProportionateScreenHeight(250),
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(bottom: 5),
                                          shrinkWrap: true,
                                          itemCount: uniBooks.length < 20
                                              ? uniBooks.length
                                              : uniBooks.sublist(0, 20).length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return UniversityBookListItem(
                                                book: uniBooks[index]);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                      if (_showPreview) ...[
                        BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5.0,
                            sigmaY: 5.0,
                          ),
                          child: Container(
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                _previewImage,
                                height: 300,
                                width: 300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  auth.user != null
                      ? auth.user.id != widget.book.userId
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Divider(color: Color(0xFFF9F9F9), thickness: 1),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: getProportionateScreenWidth(16),
                                    left: getProportionateScreenWidth(16),
                                    top: getProportionateScreenHeight(10),
                                    bottom: getProportionateScreenHeight(30),
                                  ),
                                  child: DefaultButton(
                                    press: () {
                                      _addToCart();
                                    },
                                    text: trans(context, 'add_to_cart'),
                                    total:
                                        '${double.parse(widget.book.priceService) + double.parse(widget.book.deliveryFee)} ${trans(context, 'kd')}',
                                    loading: _isAddtingToCart,
                                  ),
                                )
                              ],
                            )
                          : Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(color: Color(0xFFF9F9F9), thickness: 1),
                            Padding(
                              padding: EdgeInsets.only(
                                right: getProportionateScreenWidth(16),
                                left: getProportionateScreenWidth(16),
                                top: getProportionateScreenHeight(10),
                                bottom: getProportionateScreenHeight(30),
                              ),
                              child: DefaultButton(
                                press: () {
                                  _addToCart();
                                },
                                text: trans(context, 'add_to_cart'),
                                total:
                                    '${double.parse(widget.book.priceService) + double.parse(widget.book.deliveryFee)} ${trans(context, 'kd')}',
                                loading: _isAddtingToCart,
                              ),
                            )
                          ],
                        ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  _addToCart() async {
    var cart = Provider.of<CartProvider>(context, listen: false);
    setState(() {
      _isAddtingToCart = true;
    });
    await prefs.getUserId().then((id) async {
      if (id != null) {
        if (cart.getUserCartBooks().any((b) => b.id == widget.book.id)) {
          Toast.show(trans(context, 'book_already_exist'), context);
        } else {
          await HttpService().addToCart(context, widget.book, id);
          cart.addBookToCart(widget.book);
        }
      } else
        Navigator.popUntil(context, ModalRoute.withName(LoginScreen.routeName));
    });
    setState(() {
      _isAddtingToCart = false;
    });
  }
}
