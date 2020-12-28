import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/providers/cart_provider.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/models/cart.dart';
import 'package:ketabook/models/college.dart';
import 'package:ketabook/models/delivery_fee.dart';
import 'package:ketabook/models/delivery_time.dart';
import 'package:ketabook/models/order.dart';
import 'package:ketabook/models/order_carts.dart';
import 'package:ketabook/models/order_object.dart';
import 'package:ketabook/models/package.dart';
import 'package:ketabook/models/page_desc.dart';
import 'package:ketabook/models/photo.dart';
import 'package:ketabook/models/photo_picker.dart';
import 'package:ketabook/models/slideshow.dart';
import 'package:ketabook/models/speciality.dart';
import 'package:ketabook/models/university.dart';
import 'package:ketabook/models/user_model.dart';
import 'package:ketabook/screens/tabs_screen/tabs_screen.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class HttpService {
  SessionManager session = SessionManager();
  AppNotifier application;

  static const RETRIEVE_ALL_DATA = "RetrieveData/getData";
  static const REGISTER_USER = "UserMyApp/SignUp";
  static const LOGIN_USER = "UserMyApp/SignIn";
  static const FORGOT_PASSWORD = "UserMyApp/ForgotPassword";
  static const GET_USER_INFO = "UserMyApp/httpGetObj";
  static const ADD_BOOK = "BooksList/AddNew";
  static const GET_ALL_RECENT_BOOKS = "BooksList/getAllRecentBooks";
  static const GET_SLIDESHOW_IMAGES = "Slideshow/getHttp";
  static const GET_BOOKS_BY_SPECIALITY = "BooksList/getAllActiveBySpeciality";
  static const GET_BOOKS_BY_USER = "BooksList/getAllBooksByUser";
  static const UPDATE_PROFILE = "UserMyApp/httpUpdate";
  static const GET_BOOK_PHOTOS = "BooksList/getPhotosList";
  static const REMOVE_PHOTO = "BooksList/removePhoto";
  static const ADD_TO_CART = "UserMyApp/placeCart";
  static const GET_CART = "BooksList/getCart";
  static const GET_BOOK = "BooksList/getBook";
  static const REMOVE_FROM_CART = "BooksList/removeBookFromCart";
  static const PLACE_ORDER = "UserMyApp/placeOrder1";
  static const PLACE_ORDER_CARTS = "UserMyApp/placeOrderCarts";
  static const GET_ORDERS = "BooksList/getAllOrders";
  static const REMOVE_BOOK = "BooksList/removeBook";
  static const GET_ORDER_STATUS = "Setting/getStatusHttp";
  static const GET_PACKAGES = "Packages/getPackages";
  static const GET_USER_PACKAGE = "UserMyApp/getUserPackage";

  Future getUniversities(BuildContext context) async {
    application = Provider.of<AppNotifier>(context, listen: false);

    Response res = await post(WebService.getWebService() + RETRIEVE_ALL_DATA,
        headers: {"Content-Type": "application/json"});

    if (res.statusCode == 200) {
      final body = json.decode(res.body);

      final universitiesBody =
          body['tblUniversity'].cast<Map<String, dynamic>>();
      List<University> universities = universitiesBody
          .map<University>((json) => University.fromJson(json))
          .toList();
      application.addUniversities(universities);
      print(universities);

      final collegesBody = body['tblCollege'].cast<Map<String, dynamic>>();
      List<College> colleges =
          collegesBody.map<College>((json) => College.fromJson(json)).toList();
      application.addColleges(colleges);
      print(colleges);

      final specialitiesBody =
          body['tblSpeciality'].cast<Map<String, dynamic>>();
      List<Speciality> specialities = specialitiesBody
          .map<Speciality>((json) => Speciality.fromJson(json))
          .toList();
      application.addSpeciality(specialities);
      print(specialities);

      final pageDescBody = body['tblPageDesc'].cast<Map<String, dynamic>>();
      List<PageDesc> pageDesc = pageDescBody
          .map<PageDesc>((json) => PageDesc.fromJson(json))
          .toList();
      application.addPageDesc(pageDesc);
      print(pageDesc);

      final deliveryTimeBody =
          body['tblDeliveryTime'].cast<Map<String, dynamic>>();
      List<DeliveryTime> deliveryTime = deliveryTimeBody
          .map<DeliveryTime>((json) => DeliveryTime.fromJson(json))
          .toList();
      application.addDeliveryTime(deliveryTime);
      print(deliveryTime);

      final deliveryFeeBody =
          body['tblDeliveryFee'].cast<Map<String, dynamic>>();
      List<DeliveryFee> deliveryFee = deliveryFeeBody
          .map<DeliveryFee>((json) => DeliveryFee.fromJson(json))
          .toList();
      application.addDeliveryFee(deliveryFee);
      print(deliveryFee);
    } else {
      throw Exception('Failed to retrieve data');
    }
  }

  Future<List<Book>> getAllRecentBooks(
      BuildContext context, String userId, int limit) async {
    application = Provider.of<AppNotifier>(context, listen: false);

    Response res =
        await post(WebService.getWebService() + GET_ALL_RECENT_BOOKS, body: {
      "user_id": userId,
      "limit": limit.toString(),
    });

    if (res.statusCode == 200) {
      final body = json.decode(res.body);

      final booksBody = body.cast<Map<String, dynamic>>();
      List<Book> books =
          booksBody.map<Book>((json) => Book.fromJson(json)).toList();

      return books;
    } else {
      final body = json.decode(res.body);
      print(body);
      throw Exception('Failed to retrieve data');
    }
  }

  Future<List<Slideshow>> getSlideshowImages(BuildContext context) async {
    Response res = await post(
      WebService.getWebService() + GET_SLIDESHOW_IMAGES,
    );

    if (res.statusCode == 200) {
      final body = json.decode(res.body).cast<Map<String, dynamic>>();

      List<Slideshow> slideshow =
          body.map<Slideshow>((json) => Slideshow.fromJson(json)).toList();
      print(slideshow);

      return slideshow;
    } else {
      throw Exception('Failed to slideshow images');
    }
  }

  Future<List<Package>> getPackages() async {
    Response res = await post(WebService.getWebService() + GET_PACKAGES);

    if (res.statusCode == 200) {
      final body = json.decode(res.body).cast<Map<String, dynamic>>();

      List<Package> package =
          body.map<Package>((json) => Package.fromJson(json)).toList();
      print(package);

      return package;
    } else {
      throw Exception('Failed to slideshow images');
    }
  }

  Future<int> getUserPackage(UserModel user) async {
    Response res = await post(WebService.getWebService() + GET_USER_PACKAGE,
        body: {"id": user.id});

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      return int.parse(body['result']);
    } else {
      throw Exception('Failed to get user packages');
    }
  }

  Future<List<Book>> getBooksBySpeciality(
      BuildContext context, String specialityId) async {
    Response res = await post(
        WebService.getWebService() + GET_BOOKS_BY_SPECIALITY,
        body: {"speciality_id": specialityId});

    if (res.statusCode == 200) {
      final body = json.decode(res.body).cast<Map<String, dynamic>>();

      List<Book> books = body.map<Book>((json) => Book.fromJson(json)).toList();

      return books;
    } else {
      throw Exception('Failed to slideshow images');
    }
  }

  Future<List<Book>> getBooksByUser(BuildContext context, String userId) async {
    Response res = await post(WebService.getWebService() + GET_BOOKS_BY_USER,
        body: {"user_id": userId});

    if (res.statusCode == 200) {
      final body = json.decode(res.body).cast<Map<String, dynamic>>();

      List<Book> books = body.map<Book>((json) => Book.fromJson(json)).toList();

      return books;
    } else {
      throw Exception('Failed to retrieve user books');
    }
  }

  Future registerUser(
    BuildContext context,
    UserModel user,
  ) async {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    SessionManager session = new SessionManager();
    try {
      Response res = await post(
        WebService.getWebService() + REGISTER_USER,
        body: {
          "name": user.name,
          "phone": user.phone,
          "email": user.email,
          "password": user.password,
          "status_code": user.statusCode,
          "date_join": user.dateJoin,
          "time_join": user.timeJoin,
          "university_id": user.universityId,
          "id": user.id,
          "dob": user.dob,
          "gender": user.gender,
        },
      );

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        print(body);
        String status = body['status'];
        String message = body['message'];
        if (status == '1') {
          String id = body['id'];
          session.setUserId(id);
          await HttpService().getUserInfo().then((user) {
            if (user != null) auth.setUser(user);
          });
          await loadingDialog(context).hide();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TabsScreen()),
          );
        } else {
          if (message == 'success') {
            await loadingDialog(context).hide();
            Toast.show(trans(context, 'REGISTRATION_SUCCESS'), context);
          } else {
            await loadingDialog(context).hide();
            Toast.show(trans(context, message), context);
          }
        }
      } else {
        await loadingDialog(context).hide();
        throw Exception('Failed to register user');
      }
    } catch (e) {
      await loadingDialog(context).hide();
      print("REGISTER_USER error: $e");
    }
  }

  Future loginUser(
    BuildContext context,
    UserModel user,
  ) async {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    var cart = Provider.of<CartProvider>(context, listen: false);
    application = Provider.of<AppNotifier>(context, listen: false);
    SessionManager session = new SessionManager();
    double totalPrice = 0.0;
    List<Book> cartBooks = [];
    try {
      Response res = await post(
        WebService.getWebService() + LOGIN_USER,
        body: {
          "email": user.email,
          "password": user.password,
          "token": '',
        },
      );

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        print(body);
        String status = body['status'];

        if (status == '1') {
          String id = body['id'];
          session.setUserId(id);
          await HttpService().getUserInfo().then((user) {
            if (user != null) auth.setUser(user);
          });
          await HttpService().getCart().then((c) {
            if (c != null) {
              cart.setUserCart(c);
              c.forEach((ct) async {
                totalPrice += double.parse(ct.priceService);
                await HttpService().getBook(ct.bookId).then((book) {
                  cartBooks.add(book);
                });
              });
              cart.setUserCartBooks(cartBooks);
              cart.setCartTotalPrice(totalPrice);
            }
          });
          await loadingDialog(context).hide();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TabsScreen()),
          );
        } else if (status == '0') {
          await loadingDialog(context).hide();
          Toast.show(trans(context, 'LoginFail'), context);
        } else if (status == '2') {
          await loadingDialog(context).hide();
          Toast.show(trans(context, 'YourAccountWaitingApprove'), context);
        } else if (status == '3') {
          await loadingDialog(context).hide();
          Toast.show(trans(context, 'YourAccountBlock'), context);
        } else if (status == '4') {
          await loadingDialog(context).hide();
          Toast.show(trans(context, 'YourAccountActivateRequired'), context);
        } else {
          await loadingDialog(context).hide();
          Toast.show(trans(context, 'LoginFail'), context);
        }
      } else {
        throw Exception('Failed to login user');
      }
    } catch (e) {
      print("LOGIN_USER error: $e");
    }
  }

  Future forgotPassword(
    BuildContext context,
    String email,
  ) async {
    try {
      Response res = await post(
        WebService.getWebService() + FORGOT_PASSWORD,
        body: {"email": email},
      );

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        print(body);
        String message = body['message'];

        Toast.show(trans(context, message), context);

        await loadingDialog(context).hide();
      } else {
        throw Exception('Failed to send the password');
      }
    } catch (e) {
      print("FORGOT_PASSWORD error: $e");
    }
  }

  Future<UserModel> getUserInfo() async {
    UserModel user;
    try {
      SessionManager prefs = SessionManager();
      String userId;
      await prefs.getUserId().then((value) => userId = value);
      Response res;
      if (userId != null) {
        res = await post(WebService.getWebService() + GET_USER_INFO,
            body: {"id": userId});
      }
      if (res != null) {
        if (res.statusCode == 200) {
          final body = json.decode(res.body);
          user = UserModel.fromJson(body);
          return user;
        } else {
          throw Exception('Failed to get user info');
        }
      }
      return null;
    } catch (e) {
      print("GET_USER_INFO error: $e");
      return null;
    }
  }

  Future addBook(
      BuildContext context, Book book, List<PhotoPicker> photos) async {
    try {
      Response res = await post(
        WebService.getWebService() + ADD_BOOK,
        body: {
          "user_id": book.userId,
          "university_id": book.universityId,
          "college_id": book.collegeId,
          "speciality_id": book.specialityId,
          "name": book.name,
          "descp": book.descp,
          "price": book.price,
          "delivery_fee": book.deliveryFee,
          "date_post": book.datePost,
          "time_post": book.timePost,
          "isUpdateData": book.isUpdateData,
          "id": book.id != null ? book.id : '',
        },
      );

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        String status = body['status'];
        print(body);
        if (status == '1') {
          String id = body['id'];
          print(id);

          if (book.isUpdateData == "1") {
            if (photos.isNotEmpty)
              for (int i = 0; i < photos.length; i++) {
                await uploadImages(book.id, photos[i].image,
                    photos[i].imageName, photos[i].no);
              }
            await loadingDialog(context).hide();
            showCustomDialog(context, trans(context, 'update_successfully'),
                Icon(Icons.done, color: kPrimaryColor, size: 50), () async {
              Navigator.pop(context);
            });
          } else {
            if (photos.isNotEmpty) {
              print(photos);
            }
            for (int i = 0; i < photos.length; i++) {
              if (photos[i].image != null) {
                await uploadImages(
                    id, photos[i].image, photos[i].imageName, photos[i].no);
                await loadingDialog(context).hide();
              } else
                await loadingDialog(context).hide();
            }
            showCustomDialog(context, trans(context, 'add_successfully'),
                Icon(Icons.done, color: kPrimaryColor, size: 50), () async {
              Navigator.pop(context);
              await loadingDialog(context).hide();
            });
          }
        } else {
          await loadingDialog(context).hide();
          Toast.show(trans(context, 'book_add_fail'), context);
        }
      } else {
        await loadingDialog(context).hide();
      }
    } catch (e) {
      print("ADD_BOOK error: $e");
    }
  }

  Future addToCart(BuildContext context, Book book, String id) async {
    print(book.id);
    try {
      Response res = await post(
        WebService.getWebService() + ADD_TO_CART,
        body: {
          "user_id": id,
          "owner_id": book.userId,
          "book_id": book.id,
          "quantity": "1",
          "price": book.price,
          "delivery_fee": book.deliveryFee,
          "service_fee": book.serviceFee,
          "price_service": book.priceService
        },
      );

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        String status = body['status'];
        print(body);

        if (status == '1') {
          Toast.show(trans(context, 'cart_add_successfully'), context);
        } else {
          Toast.show(trans(context, 'book_add_fail'), context);
        }
      }
    } catch (e) {
      print("ADD_BOOK error: $e");
    }
  }

  Future placeOrderCarts(BuildContext context, OrderCarts cart) async {
    try {
      Response res = await post(
        WebService.getWebService() + PLACE_ORDER_CARTS,
        body: {
          "order_id": cart.orderId,
          "book_id": cart.bookId,
        },
      );

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        String status = body['status'];
        print(body);

        if (status == '1') {
          await loadingDialog(context).hide();
        } else {
          await loadingDialog(context).hide();
        }
      } else {
        await loadingDialog(context).hide();
      }
    } catch (e) {
      await loadingDialog(context).hide();
      print("PLACE_ORDER_CARTS error: $e");
    }
  }

  Future removebook(Book book) async {
    try {
      Response res = await post(
        WebService.getWebService() + REMOVE_BOOK,
        body: {
          "id": book.id,
        },
      );

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        print(body);
      }
    } catch (e) {
      print("PLACE_ORDER_CARTS error: $e");
    }
  }

  Future<String> placeOrder(
      BuildContext context, OrderObject order, Cart cart) async {
    print(order.userId);
    try {
      Response res = await post(
        WebService.getWebService() + PLACE_ORDER,
        body: {
          "user_id": order.userId,
          "book_owner": order.bookOwner,
          "name": order.name,
          "phone": order.phone,
          "address": order.address,
          "selectTime": order.selectTime,
          "deliveryFee": order.deliveryFee,
          "totalPrice": order.totalPrice,
          "date_order": order.dateOrder,
          "time_order": order.timeOrder,
          "status_code": order.statusCode,
          "book_id": cart.bookId,
          "quantity": cart.quantity,
          "price": cart.price,
          "service_fee": cart.serviceFee,
          "price_service": cart.priceService,
          "book_image": order.bookImage,
        },
      );

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        String status = body['status'];
        print(body);

        if (status == '1') {
          String id = body['id'];
          return id;
        } else {
          Toast.show(trans(context, 'book_add_fail'), context);
        }
      }
    } catch (e) {
      print("ADD_BOOK error: $e");
    }
    return null;
  }

  Future<List<Cart>> getCart() async {
    try {
      SessionManager prefs = SessionManager();
      String userId;
      await prefs.getUserId().then((value) => userId = value);
      Response res = await post(WebService.getWebService() + GET_CART,
          body: {"id": userId});

      if (res.statusCode == 200) {
        final body = json.decode(res.body).cast<Map<String, dynamic>>();
        List<Cart> cart =
            body.map<Cart>((json) => Cart.fromJson(json)).toList();
        return cart;
      } else {
        throw Exception('Failed to get cart');
      }
    } catch (e) {
      print("GET_CART error: $e");
      return null;
    }
  }

  Future<String> getOrderStatus() async {
    try {
      Response res = await post(WebService.getWebService() + GET_ORDER_STATUS);

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        String status = body['status'];
        return status;
      } else {
        throw Exception('Failed to get order status');
      }
    } catch (e) {
      print("GET_ORDER_STATUS error: $e");
      return null;
    }
  }

  Future<List<Order>> getOrders(String userId) async {
    try {
      SessionManager prefs = SessionManager();
      String userId;
      await prefs.getUserId().then((value) => userId = value);
      Response res = await post(WebService.getWebService() + GET_ORDERS,
          body: {"id": userId});

      if (res.statusCode == 200) {
        final body = json.decode(res.body).cast<Map<String, dynamic>>();
        List<Order> order =
            body.map<Order>((json) => Order.fromJson(json)).toList();
        return order;
      } else {
        throw Exception('Failed to get cart');
      }
    } catch (e) {
      print("GET_CART error: $e");
      return null;
    }
  }

  Future<Book> getBook(String id) async {
    try {
      Response res =
          await post(WebService.getWebService() + GET_BOOK, body: {"id": id});

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        Book book = Book.fromJson(body);
        return book;
      } else {
        throw Exception('Failed to get book');
      }
    } catch (e) {
      print("GET_BOOK error: $e");
      return null;
    }
  }

  uploadImages(String bookId, File image, String fileName, String no) async {
    var stream = ByteStream(image.openRead());

    final int length = await image.length();

    final request = MultipartRequest(
        'POST',
        Uri.parse(WebService.getWebService() +
            'BooksList/UploadPhoto?id=' +
            bookId +
            '&no=' +
            no))
      ..files.add(
          MultipartFile('UploadedImage', stream, length, filename: fileName));
    Response response = await Response.fromStream(await request.send());
    print(response.body);
  }

  Future<List<Photo>> getBookImages(String bookId) async {
    try {
      Response res = await post(WebService.getWebService() + GET_BOOK_PHOTOS,
          body: {"f_id": bookId});

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        final photos = body.cast<Map<String, dynamic>>();
        List<Photo> photosList =
            photos.map<Photo>((json) => Photo.fromJson(json)).toList();
        return photosList.reversed.toList();
      } else {
        throw Exception('Failed to slideshow images');
      }
    } catch (e) {
      print("GET_USER_INFO error: $e");
      return null;
    }
  }

  Future updateProfile(
    BuildContext context,
    UserModel user,
  ) async {
    var body;
    try {
      Response res = await post(
        WebService.getWebService() + UPDATE_PROFILE,
        body: {
          "name": user.name,
          "phone": user.phone,
          "email": user.email,
          "password": user.password,
          "status_code": user.statusCode,
          "date_join": user.dateJoin,
          "time_join": user.timeJoin,
          "university_id": user.universityId,
          "id": user.id,
          "dob": user.dob,
          "gender": user.gender,
          "address": user.address,
        },
      );

      if (res.statusCode == 200) {
        body = json.decode(res.body);
        print(body);
        String status = body['status'];
        String message = body['message'];
        if (status == '1') {
          await loadingDialog(context).hide();
          Toast.show(trans(context, 'UPDATE_SUCCESS'), context);
        } else {
          if (message == 'success') {
            await loadingDialog(context).hide();
            Toast.show(trans(context, 'UPDATE_SUCCESS'), context);
          } else {
            await loadingDialog(context).hide();
            Toast.show(trans(context, message), context);
          }
        }
      } else {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      print(body);
      print("UPDATE_PROFILE error: $e");
    }
  }

  Future removePhoto(Photo photo) async {
    Response res = await post(WebService.getWebService() + REMOVE_PHOTO, body: {
      "id": photo.id,
      "photo": photo.photo,
    });

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      print(body);
    } else {
      throw Exception('Failed to delete image');
    }
  }

  Future removeFromCart(String id) async {
    Response res =
        await post(WebService.getWebService() + REMOVE_FROM_CART, body: {
      "id": id,
    });

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      print(body);
    } else {
      throw Exception('Failed to delete book from cart');
    }
  }
}
