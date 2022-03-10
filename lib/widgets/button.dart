import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:line_icons/line_icons.dart';

import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/themes/textstyles.dart';

class CustomButton extends StatelessWidget {
  final Color btnColor;
  final Color textColor;
  final double borderWidth;
  final String? btnText;
  final Widget? child;
  final Function()? onPressed;
  final double width;
  final double height;
  final bool isLoading;
  final EdgeInsets margin;

  const CustomButton({
    Key? key,
    this.btnText,
    this.child,
    this.width = double.infinity,
    this.height = kButtonHeight,
    this.btnColor = kAccentColor,
    this.borderWidth = 0.0,
    this.textColor = Colors.white,
    this.isLoading = false,
    this.margin = EdgeInsets.zero,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(offsetSm),
        border: Border.all(
          width: borderWidth,
          color: kAccentColor,
        ),
        boxShadow: [
          kTopLeftShadow,
          kBottomRightShadow,
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(offsetSm),
        child: RaisedButton(
          focusColor: kAccentColor,
          splashColor: kAccentColor,
          hoverColor: kAccentColor,
          elevation: 0.0,
          color: borderWidth > 0 ? Colors.white : kAccentColor,
          onPressed: onPressed,
          child: Center(
            child: isLoading
                ? ProgressWidget(
                    color: borderWidth == 0 ? kPrimaryColor : kAccentColor,
                  )
                : child ??
                    Text(
                      btnText!,
                      style: CustomText.medium(
                        fontSize: fontSm,
                        color: borderWidth > 0 ? kAccentColor : textColor,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}

class GoogleButton extends Container {
  GoogleButton({
    Key? key,
    bool isLoading = false,
  }) : super(
          key: key,
          padding: const EdgeInsets.all(offsetBase),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [kPrimaryColor, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              kTopLeftShadow,
              kBottomRightShadow,
            ],
          ),
          child: isLoading
              ? ProgressWidget(size: offsetXMd)
              : const Icon(
                  LineIcons.googlePlus,
                  color: Colors.white,
                ),
        );
}

class AppleButton extends Container {
  AppleButton({
    Key? key,
    bool isLoading = false,
  }) : super(
          key: key,
          padding: const EdgeInsets.all(offsetBase),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [kPrimaryColor, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              kTopLeftShadow,
              kBottomRightShadow,
            ],
          ),
          child: isLoading
              ? ProgressWidget(size: offsetXMd)
              : const Icon(
                  LineIcons.apple,
                  color: Colors.white,
                ),
        );
}

class FacebookButton extends Container {
  FacebookButton({
    Key? key,
    bool isLoading = false,
  }) : super(
          key: key,
          padding: const EdgeInsets.all(offsetBase),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [kPrimaryColor, kAccentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              kTopLeftShadow,
              kBottomRightShadow,
            ],
          ),
          child: isLoading
              ? ProgressWidget(size: offsetXMd)
              : const Icon(
                  LineIcons.facebookF,
                  color: Colors.white,
                ),
        );
}

class ProgressWidget extends SizedBox {
  ProgressWidget({
    Key? key,
    double size = 16.0,
    double strokeWidth = 2.0,
    Color color = kPrimaryColor,
  }) : super(
          key: key,
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        );
}

class HelpButton extends StatelessWidget {
  final double size;
  final Function()? onClick;

  const HelpButton({
    Key? key,
    this.size = 24.0,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onClick,
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.white, kAccentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.help_outline,
          color: Colors.white,
          size: 14.0,
        ),
      ),
    );
  }
}
