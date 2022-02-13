import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/loading_provider.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/providers/permission_provider.dart';
import 'package:labyrinth/providers/shared_provider.dart';
import 'package:labyrinth/screens/setting/change_identify_screen.dart';
import 'package:labyrinth/screens/setting/coin_screen.dart';
import 'package:labyrinth/screens/setting/friend_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/auth/register_widget.dart';
import 'package:labyrinth/widgets/setting/profile_widget.dart';
import 'package:labyrinth/widgets/textfield.dart';

class AccountScreen extends StatefulWidget {
  final UserModel userModel;
  final Function(UserModel)? update;
  const AccountScreen({
    Key? key,
    required this.userModel,
    required this.update,
  }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserModel? _user;

  var _eventPurpose = ValueNotifier(0);
  var _eventExperience = ValueNotifier(0);

  final _boundaryKey = GlobalKey();
  var _currentDate = DateTime.now();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _user = widget.userModel;
    Timer.run(() => _initData());
  }

  void _initData() {
    setState(() {
      _eventPurpose = ValueNotifier(int.parse(_user!.usrPurpose!));
      _eventExperience = ValueNotifier(int.parse(_user!.usrExperience!));
      _currentDate = _user!.usrDOB!.getBirthDate;
    });
  }

  void _imagePicker() async {
    var permission = await PermissionProvider.checkImagePickerPermission();
    if (!permission) {
      DialogProvider.of(context).showSnackBar(
        S.current.permission_denied,
        type: SnackBarType.ERROR,
      );
      return;
    }
    DialogProvider.of(context).showBottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          S.current.choose_image_source.semiBoldText(fontSize: fontXMd),
          const SizedBox(
            height: offsetBase,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
              _pickImage(
                isCamera: true,
              );
            },
            child: S.current.by_camera.regularText(fontSize: fontMd),
          ),
          const SizedBox(
            height: offsetBase,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
              _pickImage(
                isCamera: false,
              );
            },
            child: S.current.by_gallery.regularText(fontSize: fontMd),
          ),
          const SizedBox(
            height: offsetBase,
          ),
        ],
      ),
    );
  }

  void _pickImage({
    bool isCamera = true,
  }) async {
    var _image = await _picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );

    if (_image != null) {
      var filePath = _image.path;
      LoadingProvider.of(context).show();
      var respUpload = await NetworkProvider.of().uploadFile(
        filePath: filePath,
        header: kRootAvatar,
      );
      LoadingProvider.of(context).hide();
      if (respUpload != null) {
        if (respUpload['ret'] == 10000) {
          _updateProfile({
            'usr_id': _user!.id!,
            'usr_avatar': respUpload['result'],
          });
        } else {
          DialogProvider.of(context).showSnackBar(
            respUpload['msg'],
            type: SnackBarType.ERROR,
          );
        }
      } else {
        DialogProvider.of(context).showSnackBar(
          S.current.server_error,
          type: SnackBarType.ERROR,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: S.current.account.semiBoldText(
          fontSize: fontXMd,
          color: kAccentColor,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: offsetSm,
            vertical: offsetXMd,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 80.0,
                    height: 80.0,
                    child: Stack(
                      children: [
                        _user!.usrAvatar!.isEmpty
                            ? kEmptyAvatar
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: CachedNetworkImage(
                                  width: 80.0,
                                  height: 80.0,
                                  imageUrl: _user!.usrAvatar!,
                                  placeholder: (context, url) => Stack(
                                    children: const [
                                      kEmptyAvatar,
                                      Center(
                                        child: CupertinoActivityIndicator(),
                                      ),
                                    ],
                                  ),
                                  errorWidget: (context, url, error) =>
                                      kEmptyAvatar,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () => _imagePicker(),
                            child: Container(
                              padding: const EdgeInsets.all(offsetXSm),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_enhance_rounded,
                                color: kAccentColor,
                                size: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: offsetSm,
                  ),
                  _user!.usrName!.mediumText(fontSize: fontMd),
                  '${S.current.last_updated} : ${_user!.usrUpdate!.split(" ").first}'
                      .thinText(fontSize: fontXSm),
                ],
              ),
              const SizedBox(
                height: offsetBase,
              ),
              Row(
                children: [
                  Expanded(
                    child: ProfileCard(
                      title: S.current.qr_code,
                      icon: const Icon(
                        Icons.qr_code,
                        color: kAccentColor,
                        size: 28.0,
                      ),
                      onClick: () => _showQRCode(),
                    ),
                  ),
                  Expanded(
                    child: ProfileCard(
                      title: S.current.friends,
                      icon: const Icon(
                        Icons.supervisor_account_outlined,
                        color: kAccentColor,
                        size: 28.0,
                      ),
                      onClick: () => NavigatorProvider.of(context).push(
                        screen: FriendScreen(
                          userModel: _user!,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ProfileCard(
                      title: '${_user!.usrCoin!} ${S.current.coins}',
                      icon: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: kAccentColor,
                        size: 28.0,
                      ),
                      onClick: () => NavigatorProvider.of(context).push(
                        screen: CoinScreen(
                          userModel: _user!,
                          updateCoin: (coin) {
                            setState(() {
                              _user!.usrCoin = coin.toString();
                            });
                            widget.update!(_user!);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: offsetSm,
              ),
              Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(offsetSm),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(offsetBase),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          S.current.user_information
                              .semiBoldText(fontSize: fontMd),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          ProfileItemWidget(
                            title: S.current.userID,
                            content: _user!.usrID!,
                            edit: () => _updateUserID(
                              value: _user!.usrID!,
                              keyName: 'usr_userid',
                              icon: const Icon(Icons.verified_user),
                              title: S.current.update_user_id,
                              hintText: S.current.userID,
                            ),
                          ),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          ProfileItemWidget(
                            title: S.current.fullName,
                            content: _user!.usrName!,
                            edit: () => _updateUserID(
                              value: _user!.usrName!,
                              keyName: 'usr_name',
                              icon: const Icon(Icons.account_circle),
                              title: S.current.update_user_name,
                              hintText: S.current.fullName,
                            ),
                          ),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          ProfileItemWidget(
                            title: S.current.email,
                            content: _user!.usrEmail!,
                            edit: _user!.usrType! != '0'
                                ? null
                                : () => _updateIdentify(),
                          ),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          _user!.usrType! == '0'
                              ? ProfileItemWidget(
                                  title: S.current.password,
                                  content: '********',
                                  edit: () => _updateIdentify(
                                    isEmail: false,
                                  ),
                                )
                              : _getUserType(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: offsetSm,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(offsetSm),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(offsetBase),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          S.current.identifier.semiBoldText(fontSize: fontMd),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          ProfileItemWidget(
                            title: S.current.birthday,
                            content: _user!.usrDOB!,
                            edit: () => _showCalendarPicker(),
                          ),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          ProfileItemWidget(
                            title: S.current.gender,
                            content: _user!.usrGender! == '0'
                                ? S.current.male
                                : S.current.female,
                            edit: () => _showGenderDialog(
                              value: int.parse(_user!.usrGender!),
                            ),
                          ),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          ProfileItemWidget(
                            title: S.current.country,
                            content: _user!.usrCountry!,
                            edit: () => _showCountryPicker(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: offsetSm,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(offsetSm),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(offsetBase),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          S.current.purpose.semiBoldText(fontSize: fontMd),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          S.current.purpose_of_labyrinth
                              .thinText(fontSize: fontSm),
                          ValueListenableBuilder(
                            valueListenable: _eventPurpose,
                            builder: (context, value, view) {
                              var purposes = [
                                S.current.intelligence,
                                S.current.interesting,
                                S.current.gaming,
                                S.current.meet_friend,
                                S.current.other,
                              ];
                              return Wrap(
                                children: [
                                  for (var i = 0; i < purposes.length; i++) ...{
                                    InkWell(
                                      onTap: () => _updateProfile({
                                        'usr_id': _user!.id!,
                                        'usr_purpose': i.toString(),
                                      }),
                                      child: Container(
                                        margin: const EdgeInsets.all(offsetXSm),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: offsetSm,
                                          horizontal: offsetBase,
                                        ),
                                        decoration: BoxDecoration(
                                          color: i == _eventPurpose.value
                                              ? kAccentColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(offsetXMd),
                                          border: Border.all(
                                            color: kAccentColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: purposes[i].mediumText(
                                          fontSize: fontXSm,
                                          color: i == _eventPurpose.value
                                              ? Colors.white
                                              : kAccentColor,
                                        ),
                                      ),
                                    ),
                                  },
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          S.current.experiences_of_labyrinth
                              .thinText(fontSize: fontSm),
                          ValueListenableBuilder(
                            valueListenable: _eventExperience,
                            builder: (context, value, view) {
                              var purposes = [
                                S.current.beginner,
                                S.current.medium,
                                S.current.senior,
                                S.current.expert,
                                S.current.other,
                              ];
                              return Wrap(
                                children: [
                                  for (var i = 0; i < purposes.length; i++) ...{
                                    InkWell(
                                      onTap: () => _updateProfile({
                                        'usr_id': _user!.id!,
                                        'usr_experience': i.toString(),
                                      }),
                                      child: Container(
                                        margin: const EdgeInsets.all(offsetXSm),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: offsetSm,
                                          horizontal: offsetBase,
                                        ),
                                        decoration: BoxDecoration(
                                          color: i == _eventExperience.value
                                              ? kAccentColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(offsetXMd),
                                          border: Border.all(
                                            color: kAccentColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: purposes[i].mediumText(
                                          fontSize: fontXSm,
                                          color: i == _eventExperience.value
                                              ? Colors.white
                                              : kAccentColor,
                                        ),
                                      ),
                                    ),
                                  },
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQRCode() {
    var encryptData = base64.encode(utf8.encode(_user!.toQRJson().toString()));
    DialogProvider.of(context).bubbleDialog(
      isCancelable: true,
      child: Center(
        child: Column(
          children: [
            S.current.my_qr_code.semiBoldText(fontSize: fontMd),
            const SizedBox(
              height: offsetBase,
            ),
            RepaintBoundary(
              key: _boundaryKey,
              child: QrImage(
                data: encryptData,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                size: 240.0,
              ),
            ),
          ],
        ),
      ),
      actions: [],
    );
  }

  void _updateUserID({
    required String title,
    required String value,
    required String hintText,
    required Widget icon,
    required String keyName,
  }) {
    String? _value;
    var editController = TextEditingController();
    editController.text = value;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    AutovalidateMode _autoValidate = AutovalidateMode.disabled;

    DialogProvider.of(context).bubbleDialog(
      isCancelable: true,
      child: Column(
        children: [
          title.mediumText(
            fontSize: fontMd,
          ),
          const SizedBox(
            height: offsetBase,
          ),
          Form(
            key: _formKey,
            autovalidateMode: _autoValidate,
            child: CustomTextField(
              controller: editController,
              hintText: hintText,
              prefixIcon: icon,
              textInputAction: TextInputAction.done,
              validator: (value) {
                return value!.validateValue;
              },
              onSaved: (value) {
                _value = value!;
              },
            ),
          ),
        ],
      ),
      actions: [
        S.current.dismiss.button(
          onPressed: () => Navigator.of(context).pop(),
          borderWidth: 2.0,
        ),
        S.current.update.button(
          onPressed: () {
            _autoValidate = AutovalidateMode.always;
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();
            Navigator.of(context).pop();
            _updateProfile({
              'usr_id': _user!.id!,
              keyName: _value!,
            });
          },
        ),
      ],
    );
  }

  void _showCalendarPicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
      initialDate: _currentDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kAccentColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _currentDate) {
      _currentDate = picked;
      _updateProfile({
        'usr_id': _user!.id!,
        'usr_dob': _currentDate.getBirthDate,
      });
    }
  }

  Future<void> _updateProfile(Map<String, String> param) async {
    LoadingProvider.of(context).show();
    var res = await NetworkProvider.of().post(
      kUpdateUser,
      param,
    );
    if (res != null && res['ret'] == 10000) {
      DialogProvider.of(context).showSnackBar(
        res['msg'],
      );
      _user = UserModel.fromJson(res['result']);
      widget.update!(_user!);
      _initData();
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.server_error,
        type: SnackBarType.ERROR,
      );
    }
    LoadingProvider.of(context).hide();
  }

  void _updateIdentify({
    bool isEmail = true,
  }) async {
    LoadingProvider.of(context).show();
    var resp = await NetworkProvider.of().post(
      kResendCode,
      {
        'email': _user!.usrEmail!,
      },
    );
    LoadingProvider.of(context).hide();
    if (resp != null && resp['ret'] == 10000) {
      NavigatorProvider.of(context).push(
        screen: ChangeIdentifyScreen(
          userModel: _user!,
          isEmail: isEmail,
          updateUser: (updateUser) async {
            await SharedProvider().removeBioAuth();
            setState(() {
              _user = updateUser;
              widget.update!(_user!);
            });
          },
        ),
      );
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.server_error,
        type: SnackBarType.ERROR,
      );
    }
  }

  Widget _getUserType() {
    String userType = S.current.unknown_user;
    switch (_user!.usrType!) {
      case '1':
        userType = S.current.apple_user;
        break;
      case '2':
        userType = S.current.google_user;
        break;
      case '3':
        userType = S.current.facebook_user;
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        S.current.user_type.thinText(fontSize: fontSm),
        Row(
          children: [
            userType.mediumText(),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  void _showGenderDialog({
    int value = 0,
  }) async {
    var _genderNotifier = ValueNotifier(value);
    DialogProvider.of(context).bubbleDialog(
      isCancelable: true,
      child: Column(
        children: [
          S.current.choose_gender.semiBoldText(fontSize: fontMd),
          const SizedBox(
            height: offsetBase,
          ),
          ValueListenableBuilder<int>(
            valueListenable: _genderNotifier,
            builder: (context, value, view) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GenderWidget(
                    notifier: _genderNotifier,
                    event: () {
                      Navigator.of(context).pop();
                      _updateProfile({
                        'usr_id': _user!.id!,
                        'usr_gender': '0',
                      });
                    },
                    title: S.current.male,
                    isSelected: _genderNotifier.value == 0,
                  ),
                  GenderWidget(
                    notifier: _genderNotifier,
                    event: () {
                      Navigator.of(context).pop();
                      _updateProfile({
                        'usr_id': _user!.id!,
                        'usr_gender': '1',
                      });
                    },
                    title: S.current.female,
                    isSelected: _genderNotifier.value == 1,
                  ),
                ],
              );
            },
          ),
        ],
      ),
      actions: [],
    );
  }

  void _showCountryPicker() async {
    var countryList = await Constants.getCountryList(context);
    DialogProvider.of(context).showBottomSheet(
      Column(
        children: [
          S.current.choose_country.semiBoldText(fontSize: fontXMd),
          const SizedBox(
            height: offsetBase,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var country in countryList) ...{
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        _updateProfile({
                          'usr_id': _user!.id!,
                          'usr_country': country['country'],
                        });
                      },
                      child:
                          '${country['country']} (${country['abbreviation']})'
                              .regularText(),
                    ),
                    const SizedBox(
                      height: offsetSm,
                    ),
                  },
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
