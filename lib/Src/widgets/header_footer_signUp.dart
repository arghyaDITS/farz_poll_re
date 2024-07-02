import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final width;
  Header(this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 100,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width:width,
              height: 80,
              child: Image.asset(
                'assets/images/header.png',
                fit:BoxFit.fill
                ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Container(
                width:180,
                height: 30,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit:BoxFit.fill
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  final width;
  Footer(this.width);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 2,
      child: Container(
        width:width,
        height: 50,
        child: Image.asset(
          'assets/images/header.png',
          fit:BoxFit.fill
        ),
      ),
    );
  }
}