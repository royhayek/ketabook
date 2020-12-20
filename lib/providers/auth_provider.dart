import 'package:flutter/widgets.dart';
import 'package:ketabook/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel _user;

  UserModel get user {
    return _user;
  }

  Future<bool> setUser(UserModel user) async {
    _user = user;
    notifyListeners();
    return true;
  }
}
