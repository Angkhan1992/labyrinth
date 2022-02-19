import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labyrinth/providers/encrypt_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/loading_provider.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/providers/permission_provider.dart';
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
  const AccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var _eventPurpose = ValueNotifier(0);
  var _eventExperience = ValueNotifier(0);

  final _boundaryKey = GlobalKey();
  var _currentDate = DateTime.now();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  void _imagePicker(UserModel user) async {
    var permission = await PermissionProvider.checkImagePickerPermission();
    if (!permission) {
      DialogProvider.of(context).showSnackBar(
        S.current.permission_denied,
        type: SnackBarType.error,
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
                user: user,
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
                user: user,
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
    required UserModel user,
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
          _updateProfile(user, {
            'usr_id': user.id!,
            'usr_avatar': respUpload['result'],
          });
        } else {
          DialogProvider.of(context).showSnackBar(
            respUpload['msg'],
            type: SnackBarType.error,
          );
        }
      } else {
        DialogProvider.of(context).showSnackBar(
          S.current.server_error,
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, userModel, child) {
        var user = context.read<UserModel>();
        _eventPurpose = ValueNotifier(int.parse(user.usrPurpose!));
        _eventExperience = ValueNotifier(int.parse(user.usrExperience!));
        _currentDate = user.usrDOB!.getBirthDate;
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
                            user.usrAvatar!.isEmpty
                                ? kEmptyAvatarLg
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(40.0),
                                    child: CachedNetworkImage(
                                      width: 80.0,
                                      height: 80.0,
                                      imageUrl: user.usrAvatar!,
                                      placeholder: (context, url) => Stack(
                                        children: const [
                                          kEmptyAvatarLg,
                                          Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        ],
                                      ),
                                      errorWidget: (context, url, error) =>
                                          kEmptyAvatarLg,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () => _imagePicker(user),
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
                      user.usrName!.mediumText(fontSize: fontMd),
                      '${S.current.last_updated} : ${user.usrUpdate!.split(" ").first}'
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
                          onClick: () => _showQRCode(user),
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
                            screen: const FriendScreen(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ProfileCard(
                          title: '${user.usrCoin!} ${S.current.coins}',
                          icon: const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: kAccentColor,
                            size: 28.0,
                          ),
                          onClick: () => NavigatorProvider.of(context).push(
                            screen: CoinScreen(
                              userModel: user,
                              updateCoin: (coin) {
                                user.setUsrCoin(coin.toString());
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
                                content: user.usrID!,
                                edit: () => _updateUserID(
                                  user: user,
                                  value: user.usrID!,
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
                                content: user.usrName!,
                                edit: () => _updateUserID(
                                  user: user,
                                  value: user.usrName!,
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
                                content: user.usrEmail!,
                                edit: user.usrType! != '0'
                                    ? null
                                    : () => _updateIdentify(
                                          user: user,
                                        ),
                              ),
                              const SizedBox(
                                height: offsetSm,
                              ),
                              user.usrType! == '0'
                                  ? ProfileItemWidget(
                                      title: S.current.password,
                                      content: '********',
                                      edit: () => _updateIdentify(
                                        user: user,
                                        isEmail: false,
                                      ),
                                    )
                                  : _getUserType(user),
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
                              S.current.identifier
                                  .semiBoldText(fontSize: fontMd),
                              const SizedBox(
                                height: offsetSm,
                              ),
                              ProfileItemWidget(
                                title: S.current.birthday,
                                content: user.usrDOB!,
                                edit: () => _showCalendarPicker(user),
                              ),
                              const SizedBox(
                                height: offsetSm,
                              ),
                              ProfileItemWidget(
                                title: S.current.gender,
                                content: user.usrGender! == '0'
                                    ? S.current.male
                                    : S.current.female,
                                edit: () => _showGenderDialog(
                                  user: user,
                                  value: int.parse(user.usrGender!),
                                ),
                              ),
                              const SizedBox(
                                height: offsetSm,
                              ),
                              ProfileItemWidget(
                                title: S.current.country,
                                content: user.usrCountry!,
                                edit: () => _showCountryPicker(user),
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
                                      for (var i = 0;
                                          i < purposes.length;
                                          i++) ...{
                                        InkWell(
                                          onTap: () => _updateProfile(user, {
                                            'usr_id': user.id!,
                                            'usr_purpose': i.toString(),
                                          }),
                                          child: Container(
                                            margin:
                                                const EdgeInsets.all(offsetXSm),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: offsetSm,
                                              horizontal: offsetBase,
                                            ),
                                            decoration: BoxDecoration(
                                              color: i == _eventPurpose.value
                                                  ? kAccentColor
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      offsetXMd),
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
                                      for (var i = 0;
                                          i < purposes.length;
                                          i++) ...{
                                        InkWell(
                                          onTap: () => _updateProfile(user, {
                                            'usr_id': user.id!,
                                            'usr_experience': i.toString(),
                                          }),
                                          child: Container(
                                            margin:
                                                const EdgeInsets.all(offsetXSm),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: offsetSm,
                                              horizontal: offsetBase,
                                            ),
                                            decoration: BoxDecoration(
                                              color: i == _eventExperience.value
                                                  ? kAccentColor
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      offsetXMd),
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
      },
    );
  }

  void _showQRCode(UserModel user) {
    var encryptData = jsonEncode(user.toQRJson()).encryptString;
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
    required UserModel user,
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
          color: Colors.white,
        ),
        S.current.update.button(
          onPressed: () {
            _autoValidate = AutovalidateMode.always;
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();
            Navigator.of(context).pop();
            _updateProfile(user, {
              'usr_id': user.id!,
              keyName: _value!,
            });
          },
        ),
      ],
    );
  }

  void _showCalendarPicker(UserModel user) async {
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
      _updateProfile(user, {
        'usr_id': user.id!,
        'usr_dob': _currentDate.getBirthDate,
      });
    }
  }

  Future<void> _updateProfile(UserModel user, Map<String, String> param) async {
    LoadingProvider.of(context).show();
    var res = await NetworkProvider.of().post(
      kUpdateUser,
      param,
    );
    if (res != null && res['ret'] == 10000) {
      DialogProvider.of(context).showSnackBar(
        res['msg'],
      );
      user.setFromJson(res['result']);
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.server_error,
        type: SnackBarType.error,
      );
    }
    LoadingProvider.of(context).hide();
  }

  void _updateIdentify({
    required UserModel user,
    bool isEmail = true,
  }) async {
    LoadingProvider.of(context).show();
    var resp = await NetworkProvider.of().post(
      kResendCode,
      {
        'email': user.usrEmail!,
      },
    );
    LoadingProvider.of(context).hide();
    if (resp != null && resp['ret'] == 10000) {
      NavigatorProvider.of(context).push(
        screen: ChangeIdentifyScreen(
          isEmail: isEmail,
        ),
      );
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.server_error,
        type: SnackBarType.error,
      );
    }
  }

  Widget _getUserType(UserModel user) {
    String userType = S.current.unknown_user;
    switch (user.usrType!) {
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
    required UserModel user,
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
                      _updateProfile(user, {
                        'usr_id': user.id!,
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
                      _updateProfile(user, {
                        'usr_id': user.id!,
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

  void _showCountryPicker(UserModel user) async {
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
                        _updateProfile(user, {
                          'usr_id': user.id!,
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
