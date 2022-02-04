import 'package:flutter/material.dart';
import 'package:labyrinth/themes/borders.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/textstyles.dart';

class CustomTextField extends TextFormField {
  CustomTextField({
    Key? key,
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    Function(String)? onSubmitted,
    Function()? onTap,
    bool obscureText = false,
    bool readOnly = false,
    bool circleConner = false,
    bool isMemo = false,
    TextEditingController? controller,
  }) : super(
          key: key,
          controller: controller,
          keyboardAppearance: Brightness.light,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          obscureText: obscureText,
          cursorColor: kAccentColor,
          readOnly: readOnly,
          maxLines: isMemo ? 5 : 1,
          minLines: isMemo ? 5 : 1,
          style: kTextRegular,
          decoration: InputDecoration(
            contentPadding:
                isMemo ? const EdgeInsets.all(offsetBase) : EdgeInsets.zero,
            hintText: hintText,
            errorStyle: CustomText.regular(
              fontSize: fontXSm,
              color: Colors.red,
            ),
            hintStyle: CustomText.regular(
                color: CustomColor.secondaryColor(opacity: 0.6)),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: circleConner
                ? textFieldOutBorder.copyWith(
                    borderRadius: BorderRadius.circular(60.0))
                : textFieldOutBorder,
            enabledBorder: circleConner
                ? textFieldOutBorder.copyWith(
                    borderRadius: BorderRadius.circular(60.0))
                : textFieldOutBorder,
            focusedBorder: circleConner
                ? textFieldOutBorder.copyWith(
                    borderRadius: BorderRadius.circular(60.0))
                : textFieldOutBorder,
            errorBorder: circleConner
                ? textFieldErrorOutBorder.copyWith(
                    borderRadius: BorderRadius.circular(60.0))
                : textFieldErrorOutBorder,
            disabledBorder: circleConner
                ? textFieldOutBorder.copyWith(
                    borderRadius: BorderRadius.circular(60.0))
                : textFieldOutBorder,
            focusedErrorBorder: circleConner
                ? textFieldErrorOutBorder.copyWith(
                    borderRadius: BorderRadius.circular(60.0))
                : textFieldErrorOutBorder,
          ),
          onSaved: onSaved,
          validator: validator,
          onTap: onTap,
          onFieldSubmitted: onSubmitted,
        );
}
