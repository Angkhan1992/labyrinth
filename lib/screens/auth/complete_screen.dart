import 'package:flutter/material.dart';

class CompleteScreen extends StatefulWidget {
  final Function() complete;

  const CompleteScreen({
    Key? key,
    required this.complete,
  }) : super(key: key);

  @override
  _CompleteScreenState createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
