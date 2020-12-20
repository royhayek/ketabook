import 'package:flutter/material.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/models/cart.dart';
import 'package:ketabook/services/http_services.dart';

class CartProvider extends ChangeNotifier {
  List<Book> cartBooks = List<Book>();
  List<Cart> carts = List<Cart>();
  double totalCartPrice = 0.0;

  List<Cart> getUserCart() {
    return carts;
  }

  List<Book> getUserCartBooks() {
    return cartBooks;
  }

  void setUserCart(List<Cart> cart) {
    this.carts = cart;
  }

  void setUserCartBooks(List<Book> books) {
    this.cartBooks = books;
  }

  void setCartTotalPrice(double totalPrice) {
    this.totalCartPrice = totalPrice;
  }

  void addBookToCart(Book book) {
    cartBooks.add(book);
    notifyListeners();
  }

  void removeBookFromCart(Book book) {
    cartBooks.remove(book);
    HttpService().removeFromCart(book.id);
    notifyListeners();
  }

  double getCartTotalPrice() {
    totalCartPrice = 0.0;
    cartBooks.forEach((b) {
      totalCartPrice +=
          double.parse(b.priceService) + double.parse(b.deliveryFee);
    });
    return totalCartPrice;
  }

  void removeBook(Book book) async {
    cartBooks.removeWhere((b) => b.id == book.id);
    notifyListeners();
  }

  clearUserCart() {
    this.carts.clear();
    this.cartBooks.clear();
    totalCartPrice = 0.0;
    notifyListeners();
  }

  notifyListeners();
}
