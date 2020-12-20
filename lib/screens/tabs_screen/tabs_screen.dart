import 'package:flutter/material.dart';
import 'package:ketabook/screens/account_screen/account_screen.dart';
import 'package:ketabook/screens/books_screen/books_screen.dart';
import 'package:ketabook/screens/home_screen/home_screen.dart';
import 'package:ketabook/screens/search_screen/search_screen.dart';
import 'package:ketabook/screens/sell_book_screen/sell_book_screen.dart';
import 'package:ketabook/utils/utils.dart';

import '../../size_config.dart';

class TabsScreen extends StatefulWidget {
  static String routeName = "/tabs_screen";

  static void setPageIndex(BuildContext context, int index) {
    _TabsScreenState state =
        context.findAncestorStateOfType<_TabsScreenState>();
    state._selectPage(index);
  }

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      onTap: _selectPage,
      elevation: 0,
      iconSize: SizeConfig.screenWidth / 14,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      currentIndex: _selectedPageIndex,
      // showSelectedLabels: false,
      // showUnselectedLabels: false,
      selectedLabelStyle: TextStyle(fontSize: SizeConfig.screenWidth / 25),
      unselectedLabelStyle: TextStyle(fontSize: SizeConfig.screenWidth / 25),
      unselectedItemColor: Colors.grey.shade400,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          activeIcon: Icon(Icons.home),
          label: trans(context, 'home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          activeIcon: Icon(Icons.menu_book),
          label: trans(context, 'books'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          activeIcon: Icon(Icons.add_circle_outline),
          label: trans(context, 'sell'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          activeIcon: Icon(Icons.search),
          label: trans(context, 'search'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          activeIcon: Icon(Icons.person),
          label: trans(context, 'account'),
        ),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: <Widget>[
        _pages[_selectedPageIndex]['page'],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      {'page': HomeScreen()},
      {'page': BooksScreen(title: 'books', implyLeading: false)},
      {'page': SellBookScreen()},
      {'page': SearchScreen()},
      {'page': AccountScreen()},
    ];
    return Scaffold(
      body: _body(context),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }
}
