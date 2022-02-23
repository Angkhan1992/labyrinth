import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/utils/extension.dart';

class RoomModel extends ChangeNotifier {
  String id = '';
  String name = '';
  String amount = '';
  String regDate = '';

  List<UserModel> _users = [];
  List<UserModel> _invites = [];
  List<UserModel> _tours = [];

  var _status = RoomStatus.waiting;

  RoomModel();

  void setFromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['rm_name'];
    amount = json['rm_user_amount'];
    regDate = json['regdate'];
    var status = json['rm_status'];
    _status = RoomStatus.waiting;
    switch (status) {
      case 'prepare':
        _status = RoomStatus.prepare;
        break;
      case 'play':
        _status = RoomStatus.play;
        break;
      case 'result':
        _status = RoomStatus.result;
        break;
    }

    if (json['users'] != null) {
      _users = (json['users'] as List)
          .map((e) => UserModel()..setFromJson(e))
          .toList();
    }
    if (json['invites'] != null) {
      _invites = (json['invites'] as List)
          .map((e) => UserModel()..setFromJson(e))
          .toList();
    }
    if (json['tours'] != null) {
      _tours = (json['tours'] as List)
          .map((e) => UserModel()..setFromJson(e))
          .toList();
    }

    notifyListeners();
  }

  void addUser(UserModel user) {
    for (var listUser in _users) {
      if (listUser.id! == user.id!) {
        return;
      }
    }
    _users.add(user);
    notifyListeners();
  }

  UserModel? getUser(int index) {
    if (kDebugMode) {
      print('[Room] users : ${_users.length}');
    }
    if (index > _users.length - 1) return null;
    return _users[index];
  }

  void removeUser(String userid) {
    for (var user in _users) {
      if (user.id! == userid) {
        _users.remove(user);
        break;
      }
    }
    notifyListeners();
  }

  void addInvites(UserModel viewer) {
    _invites.add(viewer);
    notifyListeners();
  }

  UserModel getInviteUser(int index) {
    return _invites[index];
  }

  void addTour(UserModel tour) {
    _tours.add(tour);
    notifyListeners();
  }

  UserModel getTourUser(int index) {
    return _tours[index];
  }

  void setStatus(RoomStatus status) {
    _status = status;
    notifyListeners();
  }

  RoomStatus getStatus() {
    return _status;
  }

  Widget listWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: offsetBase,
        vertical: offsetSm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(offsetSm),
        boxShadow: [
          kTopLeftShadow,
          kBottomRightShadow,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              amount == '2'
                  ? const Icon(
                      Icons.looks_two_outlined,
                      color: Colors.green,
                      size: 18.0,
                    )
                  : const Icon(
                      Icons.looks_4_outlined,
                      color: Colors.red,
                      size: 18.0,
                    ),
              const SizedBox(
                width: offsetSm,
              ),
              name.thinText(
                color: kAccentColor,
                fontSize: fontSm,
              ),
            ],
          ),
          const SizedBox(
            height: offsetSm,
          ),
          Row(
            children: [
              'Amount : '.thinText(fontSize: fontXSm),
              '$amount Users'.mediumText(fontSize: fontXSm),
            ],
          ),
          Row(
            children: [
              'Created : '.thinText(fontSize: fontXSm),
              regDate.mediumText(fontSize: fontXSm),
            ],
          ),
        ],
      ),
    );
  }
}

enum RoomStatus {
  waiting,
  prepare,
  play,
  result,
}

extension ERoomStatus on RoomStatus {
  String get rawValue {
    switch (this) {
      case RoomStatus.waiting:
        return 'waiting';
      case RoomStatus.prepare:
        return 'prepare';
      case RoomStatus.play:
        return 'play';
      case RoomStatus.result:
        return 'result';
    }
  }

  bool get isWaiting {
    return this == RoomStatus.waiting;
  }

  bool get isPrepare {
    return this == RoomStatus.prepare;
  }

  bool get isPlay {
    return this == RoomStatus.play;
  }

  bool get isResult {
    return this == RoomStatus.result;
  }
}
