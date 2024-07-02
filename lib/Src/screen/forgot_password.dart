import 'dart:convert';

import 'package:farz_poll_re/Src/controller/registrationController.dart';
import 'package:farz_poll_re/Src/fonts/fonts.dart';
import 'package:farz_poll_re/Src/screen/login.dart';
import 'package:farz_poll_re/Src/widgets/header_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({ Key? key }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final RegistrationController _registrationController = Get.put(RegistrationController());
  TextEditingController _forgotPassEmailController = TextEditingController();
  double width = 0.0;
  double height = 0.0;
  double statusBarHeight = 0.0;
  bool buttonPressed = false;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height-statusBarHeight;
    statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top:statusBarHeight),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(width),
              Container(
                height: height-150-120,
                child: Column(
                  children: [
                    Text("Reset Password?",style: Fonts.regular(30, Colors.blue[900]!),),
              SizedBox(height: 20,),
              textFieldNew("Email",Icons.email,_forgotPassEmailController),
              SizedBox(height: 20,),
              InkWell(
              onTap: (){
                setState(() {
                  buttonPressed=true;
                });
                if(validation()==true){
                  forgetPassFunction();
                }
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color:  (buttonPressed)?Colors.orange:Colors.orange[700]!,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text("Send Password Reset Link",style: Fonts.bold(12, Colors.white),),
                ),
              ),
              ),
              SizedBox(height: 20,),
              InkWell(
              onTap: (){
               Get.to(()=>Login());
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text("Sign in",style: Fonts.bold(20, Colors.white),),
                ),
              ),
              ),
              SizedBox(height: 30,),
                  ],
                ),
              ),
            Footer(width)
               ],
          ),
        ),
      )
    );
  }

  Widget textField(String hint, IconData icon , TextEditingController controller){
    return Container(
              width: width/1.2,
              height: 70,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: width/1.2,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                      ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:70,right: 25,bottom: 6),
                        child: TextField(
                          controller: controller,
                          style:Fonts.regular(18, Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: hint,
                            hintStyle: Fonts.regular(15, Colors.grey)
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment:Alignment.centerLeft,
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                        color: Colors.grey,
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                        ]
                      ),
                      child:Icon(icon,size: 30,color: Colors.blue[900],)
                    ),
                  ),
                ],
              )
            );
  }

    Widget textFieldNew(String hint, IconData icon , TextEditingController controller){
    return Container(
      width: width/1.2,
      height: 40,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width:2,color: Colors.blue[800]!))
      ),
      child: Padding(
        padding: const EdgeInsets.only(left:15,right: 25,bottom: 8),
        child: TextField(
          controller: controller,
          style:Fonts.regular(18, Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: Fonts.regular(15, Colors.grey)
          ),
        ),
      ),
    );
  }


  forgetPassFunction() async{
  var data = {
    "email": _forgotPassEmailController.text,
    };
  var response = await _registrationController.forgotPasswordHandler(jsonEncode(data));
  if(response['result']=='success'){
      customDialog(response['data']['success']);
      Get.to(()=>Login);
  }else{
    customDialog(response['data']['error']['email'][0].toString());
  }
}


validation(){
  if(_forgotPassEmailController.text==''){
    customDialog("Please enter your Email");
    return false;
  }else{
    return true;
  }
}

customDialog(String text){
  showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Forgot Password"),
                  content: Text(text),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          buttonPressed=false;
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: Text("okay"),
                    ),
                  ],
                ),
              );
}
}