import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final width;
  Logo(this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 48,
      child:Image.asset("assets/images/logo.png",fit: BoxFit.fill,)
    );
  }
}