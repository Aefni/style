import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
