import 'package:flutter/material.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/services/http_services.dart';

class DataProvider with ChangeNotifier {
  List<Book> _allRecentBooks = List<Book>();
  List<Book> _limitedRecentBooks = List<Book>();

  List<Book> get allRecentBooks {
    return [..._allRecentBooks];
  }

  List<Book> get limitedRecentBooks {
    return [..._limitedRecentBooks];
  }

  // Book findBookById(int id) {
  //   return _allRecentBooks.firstWhere((prod) => prod.id == id);
  // }

  void clearAllRecentBooks() {
    _allRecentBooks.clear();
    notifyListeners();
  }

  void clearLimitedRecentBooks() {
    _limitedRecentBooks.clear();
    notifyListeners();
  }

  Future<void> fetchLimitedRecentBooks(
      {BuildContext context, String id}) async {
        
    if (_limitedRecentBooks.isNotEmpty) {
      return;
    }

    final List<Book> loadedBooks =
        await HttpService().getAllRecentBooks(context, id, 20);

    if (loadedBooks == null) {
      return;
    }
    _limitedRecentBooks = loadedBooks;
    print('GOT LIMITED RECENT BOOKS: $_limitedRecentBooks');
    notifyListeners();
  }

  Future<void> fetchAllRecentBooks({BuildContext context, String id}) async {
    if (_allRecentBooks.isNotEmpty) {
      return;
    }

    final List<Book> loadedBooks =
        await HttpService().getAllRecentBooks(context, id, null);

    if (loadedBooks == null) {
      return;
    }
    _allRecentBooks = loadedBooks;
    print('GOT ALL RECENT BOOKS: $_allRecentBooks');
    notifyListeners();
  }
  
}
