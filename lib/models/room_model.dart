import 'package:flutter/material.dart';
import 'package:labyrinth/models/user_model.dart';

class RoomModel extends ChangeNotifier {
  String name = '';
  String userAmount = '';
  String regdate = '';
  List<UserModel> _users = [];
  List<UserModel> _viewers = [];

  void addUser(UserModel user) {
    _users.add(user);
    notifyListeners();
  }

  void addViewer(UserModel viwer) {
    _viewers.add(viwer);
    notifyListeners();
  }
}
