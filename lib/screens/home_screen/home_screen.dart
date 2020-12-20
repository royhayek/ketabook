import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/providers/cart_provider.dart';
import 'package:ketabook/providers/data_provider.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/models/slideshow.dart';
import 'package:ketabook/models/university.dart';
import 'package:ketabook/screens/books_screen/books_screen.dart';
import 'package:ketabook/screens/home_screen/widgets/banner_list_item.dart';
import 'package:ketabook/screens/tabs_screen/tabs_screen.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/list_view_title.dart';
import 'package:ketabook/screens/home_screen/widgets/recent_books_list_item.dart';
import 'package:ketabook/screens/home_screen/widgets/home_universities_list_item.dart';
import 'package:ketabook/screens/shopping_cart_screen/shopping_cart_screen.dart';
import 'package:ketabook/screens/universities_colleges_screen/universities_colleges_screen.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/widgets/search_text_field.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  SessionManager prefs = SessionManager();
  AppNotifier application;
  DataProvider data;
  AuthProvider auth;
  List<Slideshow> slideshowImages = [];
  List<University> universities = [];
  List<Book> recentBooks = [];
  int cartTotalCount = 0;
  String userId;
  String keyword;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);
    data = Provider.of<DataProvider>(context, listen: false);
    auth = Provider.of<AuthProvider>(context, listen: false);

    universities = application.getUniversities();

    if (application.getSlideShowImages() != null) {
      setState(() {
        slideshowImages = application.getSlideShowImages();
      });
    }

    if (data.allRecentBooks.isEmpty) {
      data.fetchAllRecentBooks(
          context: context,
          id: auth.user != null
              ? auth.user != null
                  ? auth.user.id
                  : ''
              : '');
    }

    if (data.limitedRecentBooks.isEmpty) {
      data.fetchLimitedRecentBooks(
          context: context,
          id: auth.user != null
              ? auth.user != null
                  ? auth.user.id
                  : ''
              : '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF9F9F9),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: SizeConfig.screenHeight / 5,
                  child: Column(
                    children: [
                      SizedBox(height: getProportionateScreenHeight(25)),
                      Text(
                        'Ketabook',
                        style: Theme.of(context).textTheme.headline6.merge(
                              TextStyle(
                                color: kPrimaryColor,
                                fontSize: SizeConfig.screenWidth / 20,
                              ),
                            ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Card(
                                elevation: 10,
                                shadowColor:
                                    Theme.of(context).cardTheme.shadowColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        SizeConfig.screenWidth / 50),
                                  ),
                                ),
                                child: SearchTextField(
                                    label: trans(context, 'search_for_books'),
                                    controller: searchController,
                                    onSubmitted: (String str) {
                                      setState(() {
                                        keyword = str;
                                      });
                                      application.setKeyword(keyword);
                                      TabsScreen.setPageIndex(context, 3);
                                    }),
                              ),
                            ),
                            SizedBox(width: getProportionateScreenWidth(8)),
                            InkWell(
                              onTap: () async {
                                Navigator.pushNamed(
                                        context, ShoppingCartScreen.routeName)
                                    .then((value) {});
                              },
                              child: Container(
                                height: SizeConfig.screenHeight / 12,
                                width: SizeConfig.screenWidth / 6.4,
                                child: Card(
                                  elevation: 10,
                                  shadowColor:
                                      Theme.of(context).cardTheme.shadowColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          SizeConfig.screenWidth / 50),
                                    ),
                                  ),
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Image.asset(
                                            'assets/images/ic_cart.png',
                                            width: SizeConfig.screenWidth / 2.4,
                                          ),
                                        ),
                                        // cartTotalCount != 0
                                        //     ?

                                        Consumer<CartProvider>(
                                          builder: (context, model, child) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(7.0),
                                              child: model
                                                          .getUserCartBooks()
                                                          .length !=
                                                      0
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Color(0xFFFF3B30),
                                                        child: FittedBox(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                              1.0,
                                                            ),
                                                            child: Text(
                                                              model
                                                                  .getUserCartBooks()
                                                                  .length
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: SizeConfig
                                                                        .screenWidth /
                                                                    35,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        radius: SizeConfig
                                                                .screenWidth /
                                                            50,
                                                      ),
                                                    )
                                                  : Container(),
                                            );
                                          },
                                        )
                                        // : Container()
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: getProportionateScreenHeight(13)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight / 4,
                        child: slideshowImages.isNotEmpty
                            ? MediaQuery.removePadding(
                                context: context,
                                removeLeft: true,
                                child: CarouselSlider.builder(
                                  options: CarouselOptions(
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: true,
                                    autoPlay: true,
                                    viewportFraction: 1,
                                    height: getProportionateScreenHeight(200),
                                  ),
                                  itemCount: slideshowImages.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          BannerListItem(
                                    slideshow: slideshowImages[index],
                                  ),
                                ),
                              )
                            : Container(
                                height: SizeConfig.screenHeight / 4,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                      ),
                      Padding(
                        padding: application.getLanguage() == "English"
                            ? EdgeInsets.only(
                                left: getProportionateScreenWidth(16),
                                top: getProportionateScreenHeight(13))
                            : EdgeInsets.only(
                                right: getProportionateScreenWidth(16),
                                top: getProportionateScreenHeight(13)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListViewTitle(
                              title:
                                  trans(context, 'universities_and_colleges'),
                              function: () => Navigator.pushNamed(
                                context,
                                UniversitiesCollegesScreen.routeName,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 13),
                              height: SizeConfig.screenHeight / 6.5,
                              child: ListView.builder(
                                cacheExtent: 20,
                                itemCount: universities.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return HomeUniversityListItem(
                                      university: universities[index]);
                                },
                              ),
                            ),
                            SizedBox(height: getProportionateScreenWidth(15)),
                            ListViewTitle(
                              title: trans(context, 'recent_books'),
                              function: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BooksScreen(
                                    title: "recent_books",
                                    implyLeading: true,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            Container(
                              height: SizeConfig.screenHeight / 3.4,
                              child: Consumer<DataProvider>(
                                  builder: (context, value, child) {
                                if (value.limitedRecentBooks.isNotEmpty)
                                  return ListView.builder(
                                    cacheExtent: 20,
                                    itemCount: value.limitedRecentBooks.length,
                                    padding: EdgeInsets.only(bottom: 5),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return RecentBooksListItem(
                                        book: value.limitedRecentBooks[index],
                                      );
                                    },
                                  );
                                else
                                  return Center(
                                    child:
                                        Text(trans(context, 'no_books_found')),
                                  );
                              }),
                            ),
                            SizedBox(height: getProportionateScreenHeight(30)),
                          ],
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
    );
  }
}
