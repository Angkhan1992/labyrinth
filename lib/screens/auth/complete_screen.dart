import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CompleteScreenState createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
        const Duration(seconds: 3), () => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(offsetXMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 90.0,
              ),
              const SizedBox(
                height: offsetSm,
              ),
              S.current.success_register.semiBoldText(fontSize: fontXMd),
              const SizedBox(
                height: offsetXMd,
              ),
              S.current.success_register_detail.regularText(fontSize: fontSm),
            ],
          ),
        ),
      ),
    );
  }
}
