import 'package:flutter/material.dart';

class Fonts{
  static regular(double size,Color color){
    return TextStyle(
       fontFamily: 'Georgia',
       color: color,
       fontSize: size,
       fontWeight: FontWeight.w400,
    );
  }

  static bold(double size,Color color){
    return TextStyle(
       fontFamily: 'Georgia',
       color: color,
       fontSize: size,
       fontWeight: FontWeight.w700,
    );
  }
}