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
    _users = (json['users'] as List)
        .map((e) => UserModel()..setFromJson(e))
        .toList();
    _invites = (json['invites'] as List)
        .map((e) => UserModel()..setFromJson(e))
        .toList();
    _tours = (json['tours'] as List)
        .map((e) => UserModel()..setFromJson(e))
        .toList();

    notifyListeners();
  }

  void addUser(UserModel user) {
    _users.add(user);
    notifyListeners();
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

  void addTour(UserModel tour) {
    _tours.add(tour);
    notifyListeners();
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
      padding: const EdgeInsets.all(offsetSm),
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
          name.mediumText(
            color: kAccentColor,
          ),
          Row(
            children: [
              'User Amount : '.thinText(fontSize: fontSm),
              '$amount Users Room'.mediumText(fontSize: fontSm),
            ],
          ),
          Row(
            children: [
              'Created Date : '.thinText(fontSize: fontSm),
              regDate.mediumText(fontSize: fontSm),
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
