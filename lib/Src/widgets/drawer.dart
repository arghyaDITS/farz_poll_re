import 'package:farz_poll_re/Src/fonts/fonts.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final height,width,statusBarHeight;
  CustomDrawer(this.height,this.width,this.statusBarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:statusBarHeight),
      child: Container(
                height: height,
                width: width/1.4,
                color: Color.fromRGBO(72, 66, 245,1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width/1.9,
                          height: 40,
                          child: Image.asset('assets/images/logo.png',fit: BoxFit.fill,),
                        ),
                      ],
                    ),
                    SizedBox(height: 40,),
                    drawerContainer("Share App", Icons.share),
                    SizedBox(height: 20,),
                    drawerContainer("Rating", Icons.star),
                    SizedBox(height: 20,),
                    drawerContainer("Password Change", Icons.lock)
                  ],
                )
              ),
    );
  }

   Widget drawerContainer(String text, IconData icon){
    return Container(
                    width: width/1.9,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(100),topRight: Radius.circular(100))
                    ),
                    child:Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                          child: Icon(icon,color: Color.fromRGBO(72, 66, 245,1),size: 26,),
                        ),
                        Text(text,style: Fonts.bold(14,Color.fromRGBO(72, 66, 245,1) ),)
                      ],
                    )
                  );
  }
}