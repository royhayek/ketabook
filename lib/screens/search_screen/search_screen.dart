import 'package:flutter/material.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/providers/data_provider.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/models/college.dart';
import 'package:ketabook/models/speciality.dart';
import 'package:ketabook/models/university.dart';
import 'package:ketabook/screens/filter_screen/filter_screen.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/book_list_item.dart';
import 'package:ketabook/widgets/search_text_field.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SessionManager prefs = SessionManager();
  AppNotifier application;
  DataProvider data;
  AuthProvider auth;
  TextEditingController searchController = TextEditingController();
  List<Book> _books = [];
  List<Book> _searchResult = [];

  List<University> allUnis = [];
  List<College> allColleges = [];
  List<Speciality> allMajors = [];

  bool searched = false;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);
    data = Provider.of<DataProvider>(context, listen: false);
    auth = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      allUnis = application.getUniversities();
      allColleges = application.getColleges();
      allMajors = application.getSpecialities();
    });

    if (data.allRecentBooks.isNotEmpty) {
      setState(() {
        _books = data.allRecentBooks;
      });
    } else {
      _getAllRecentBooks();
    }

    if (application.getKeyword() != null) {
      searched = true;
      setState(() {
        searchController.text = application.getKeyword();
        _searchResult = _books
            .where((e) => e.name
                .toLowerCase()
                .contains(application.getKeyword().toLowerCase()))
            .toList();
      });
    }
  }

  _getAllRecentBooks() async {
    await data.fetchAllRecentBooks(
        context: context, id: auth.user != null ? auth.user.id : '');

    setState(() {
      _books = data.allRecentBooks;
    });
  }

  setFilterOptions(
      String university, String faculty, String major, String name) {
    setState(() {
      searched = true;
    });

    setState(() {
      _searchResult = data.allRecentBooks
          .where((b) =>
              b.universityId == university &&
              b.collegeId == faculty &&
              b.specialityId == major &&
              b.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    });
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {
        searched = false;
      });
      return;
    } else if (text.length > 1) {
      setState(() {
        searched = true;
      });
    }

    _books.forEach((product) {
      if (product.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(product);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: SizeConfig.screenHeight / 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FilterScreen(applyFilter: setFilterOptions),
                          ),
                        );
                      },
                      child: ImageIcon(
                        AssetImage('assets/images/ic_filter.png'),
                        size: SizeConfig.screenWidth / 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: SizeConfig.screenHeight / 16,
                      child: SearchTextField(
                        label: trans(context, 'search...'),
                        controller: searchController,
                        onChanged: onSearchTextChanged,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFEFEFF4),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.screenWidth / 50),
                      ),
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(10)),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          searched = false;
                          _searchResult.clear();
                          searchController.clear();
                        });
                      },
                      child: Text(
                        trans(context, 'cancel'),
                        style: Theme.of(context).textTheme.headline6.merge(
                              TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: getProportionateScreenWidth(16),
                              ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(25)),
            _searchResult.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(16),
                      ),
                      itemCount: _searchResult.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return BookListItem(book: _searchResult[index]);
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: Text(
                        searched
                            ? trans(context, 'no_books_found')
                            : trans(context, 'start_searching_for_books'),
                        style: Theme.of(context).textTheme.headline6.merge(
                              TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: getProportionateScreenWidth(18),
                              ),
                            ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
