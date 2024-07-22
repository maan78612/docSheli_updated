import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  String msg;
  EmptyScreen({this.msg = "no data found"});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Text(msg),
      ),
    );
  }
}
