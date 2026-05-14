import 'package:flutter/cupertino.dart';
import 'package:linkaty/features/auth/models/user_model.dart';
import 'package:linkaty/features/auth/services/user_service.dart';

class UsersProvider extends ChangeNotifier {

  List<UserModel> users = [];
  bool isLoading = false;
  String? error;

  Future<void> getUsers({bool refresh = false}) async {

    if (users.isNotEmpty && !refresh) return;

    try {

      isLoading = true;
      error = null;

      notifyListeners();

      users = await UserService().getAllUsersOnce();

    } catch (e) {

      error = e.toString();

    } finally {

      isLoading = false;
      notifyListeners();

    }
  }
}