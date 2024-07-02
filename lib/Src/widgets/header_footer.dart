import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final width;
  Header(this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 150,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width:width,
              height: 120,
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
                width:220,
                height: 40,
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
        height: 120,
        child: Image.asset(
          'assets/images/header.png',
          fit:BoxFit.fill
        ),
      ),
    );
  }
}