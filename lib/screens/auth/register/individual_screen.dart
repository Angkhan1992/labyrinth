import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:line_icons/line_icons.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/auth/register_widget.dart';
import 'package:labyrinth/widgets/textfield.dart';

class IndividualScreen extends StatefulWidget {
  final String userid;
  final Function() next;
  final Function()? previous;
  final Function(bool) progress;

  const IndividualScreen({
    Key? key,
    required this.userid,
    required this.next,
    this.previous,
    required this.progress,
  }) : super(key: key);

  @override
  _IndividualScreenState createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {
  ValueNotifier<IndividualEvent>? _event;

  final _genderController = TextEditingController();
  final _dobController = TextEditingController();
  final _countryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _autoValidate = AutovalidateMode.disabled;

  var _genderValue = 0;
  var _currentDate = DateTime(1990, 1, 1);

  var _gender = '';
  var _birth = '';
  var _country = '';

  @override
  void initState() {
    super.initState();

    _event = ValueNotifier(IndividualEvent.none);

    _dobController.text = DateFormat('MM/dd/yyyy').format(_currentDate);
  }

  @override
  void dispose() {
    _genderController.dispose();
    _dobController.dispose();
    _countryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _autoValidate = AutovalidateMode.always;
      },
      child: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: _event!,
          builder: (context, value, view) {
            return Column(
              children: [
                Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: offsetBase),
                    padding: const EdgeInsets.all(offsetBase),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(offsetBase),
                      boxShadow: [
                        kTopLeftShadow,
                        kBottomRightShadow,
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        S.current.add_user_data.semiBoldText(fontSize: fontXMd),
                        const SizedBox(
                          height: offsetSm,
                        ),
                        S.current.add_user_detail.thinText(fontSize: fontSm),
                        const SizedBox(
                          height: offsetBase,
                        ),
                        S.current.gender.thinText(),
                        const SizedBox(
                          height: offsetSm,
                        ),
                        CustomTextField(
                          hintText: S.current.gender,
                          controller: _genderController,
                          prefixIcon: const Icon(LineIcons.genderless),
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                          readOnly: true,
                          validator: (gender) {
                            return gender!.validateValue;
                          },
                          onSaved: (gender) {
                            _gender = gender!;
                          },
                          onTap: () => _showGenderDialog(
                            value: _genderValue,
                          ),
                        ),
                        const SizedBox(
                          height: offsetBase,
                        ),
                        S.current.birth.thinText(),
                        const SizedBox(
                          height: offsetSm,
                        ),
                        CustomTextField(
                          hintText: S.current.birth,
                          controller: _dobController,
                          prefixIcon: const Icon(LineIcons.birthdayCake),
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                          readOnly: true,
                          validator: (birth) {
                            return birth!.validateValue;
                          },
                          onSaved: (birth) {
                            _birth = birth!;
                          },
                          onTap: () => _showCalendarPicker(),
                        ),
                        const SizedBox(
                          height: offsetBase,
                        ),
                        S.current.country.thinText(),
                        const SizedBox(
                          height: offsetSm,
                        ),
                        CustomTextField(
                          hintText: S.current.country,
                          controller: _countryController,
                          prefixIcon: const Icon(LineIcons.language),
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                          readOnly: true,
                          validator: (country) {
                            return country!.validateValue;
                          },
                          onSaved: (country) {
                            _country = country!;
                          },
                          onTap: () => _showCountryPicker(),
                        ),
                        const SizedBox(
                          height: offsetSm,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: offsetBase,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: offsetBase),
                  child: Row(
                    children: [
                      if (widget.previous != null)
                        Expanded(
                          child: S.current.previous.button(
                            borderWidth: 2.0,
                            onPressed: () => _previous(),
                          ),
                        ),
                      Expanded(
                        child: S.current.next.button(
                          isLoading: _event!.value == IndividualEvent.next,
                          onPressed: () => _next(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: offsetXMd,
                ),
              ],
            );
          },
        ),
      ),
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
                      _genderValue = 0;
                      _genderNotifier.value = 0;
                      _genderController.text = S.current.male;
                      Navigator.of(context).pop();
                    },
                    title: S.current.male,
                    isSelected: _genderNotifier.value == 0,
                  ),
                  GenderWidget(
                    notifier: _genderNotifier,
                    event: () {
                      _genderValue = 1;
                      _genderNotifier.value = 1;
                      _genderController.text = S.current.female;
                      Navigator.of(context).pop();
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
      setState(() {
        _currentDate = picked;
        _dobController.text = DateFormat('MM/dd/yyyy').format(_currentDate);
      });
    }
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
                        _countryController.text = country['country'];
                        Navigator.of(context).pop();
                        setState(() {});
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

  void _previous() async {
    if (_event!.value != IndividualEvent.none) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }
    widget.previous!();
  }

  void _next() async {
    if (_event!.value != IndividualEvent.none) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }

    _autoValidate = AutovalidateMode.always;
    if (!_formKey.currentState!.validate()) {
      DialogProvider.of(context).showSnackBar(
        S.current.not_complete_field,
        type: SnackBarType.ERROR,
      );
      return;
    }
    _formKey.currentState!.save();

    _event!.value = IndividualEvent.next;
    widget.progress(true);
    var resp = await NetworkProvider.of().post(
      kAddIndividual,
      {
        'gender': _gender == S.current.male ? '0' : '1',
        'birth': DateFormat('yyyy-MM-dd').format(_currentDate),
        'country': _country,
        'userid': widget.userid,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var user = resp['result']['updated'];
        if (kDebugMode) {
          print('[Individual] user : $user');
        }
        widget.next();
      } else {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
          type: SnackBarType.ERROR,
        );
      }
    }
    _event!.value = IndividualEvent.none;
    widget.progress(false);
  }
}

enum IndividualEvent {
  none,
  next,
}
