import 'dart:convert';
import 'package:farz_poll_re/Src/controller/registrationController.dart';
import 'package:farz_poll_re/Src/fonts/fonts.dart';
import 'package:farz_poll_re/Src/widgets/header_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final RegistrationController _registrationController = Get.put(RegistrationController());
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  double width = 0.0;
  double height = 0.0;
  double statusBarHeight = 0.0;
  bool loading = true;
  bool buttonPressed = false;


  countryPopulate()async{
     var res = await  _registrationController.countryPoulate();
     if(res==true){
        setState(() {
          loading=false;
        });
       print("Country Fetched");
     } else{
       print("Api Fetched Error");
     }
  }

  checkLoggedIn() async {
    var value = await _registrationController.getValue();
    if(value == 0987654321){
       countryPopulate();
    }else{
      _registrationController.userId.value=value;
    //  Get.offAll(()=>Dashboard());
    }
  }


  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }


  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height-statusBarHeight;
    statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: (loading==true) ?
      Container(
        height: height,
        width:width,
        color:Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 60,
              child: Image.asset('assets/images/logo.png',fit: BoxFit.fill,),
            ),
            SizedBox(height: 60,),
            CircularProgressIndicator(),
          ],
        ),
      ) : Padding(
        padding: EdgeInsets.only(top:statusBarHeight),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(width),
              Container(
                height: height-120-150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Welcome Back!",style: Fonts.regular(30, Colors.blue[900]!),),
                    //   SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,bottom: 20),
                      child: Text("Login to your account",style: Fonts.regular(18, Colors.orange[700]!),),
                    ),
                    //  SizedBox(height: 20,),
                    textFieldNew("Email",Icons.email,_emailController),
                    SizedBox(height: 5,),
                    passFieldNew("Password",Icons.lock,_passwordController),
                    //  SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                      //  Get.to(()=>ForgotPassword());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: Text("Forgot Password?",style: Fonts.regular(18, Colors.orange[700]!),),
                      ),
                    ),
                    //  SizedBox(height: 20,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical:15.0),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            buttonPressed=true;
                          });
                          if(validation()==true){
                            loginFunction();
                          }else{
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            color: (buttonPressed)?Colors.blue:Colors.blue[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text("Sign in",style: Fonts.bold(20, Colors.white),),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    InkWell(
                      onTap:(){
                      //  Get.to(()=>Signup());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Dont have and account?",style: Fonts.regular(18, Colors.black,)),
                          SizedBox(width: 10,),
                          Text("Signup",style: Fonts.regular(18, Colors.orange[700]!),)
                        ],
                      ),
                    ),
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
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:70,right: 25,bottom: 6),
                child: TextField(
                  controller: controller,
                  style:Fonts.regular(18, Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: Fonts.regular(15, Colors.grey),
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
                ],
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


  Widget passFieldNew(String hint, IconData icon , TextEditingController controller){
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
          obscureText: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: Fonts.regular(15, Colors.grey)
          ),
        ),
      ),
    );
  }


    Widget passField(String hint, IconData icon , TextEditingController controller){
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
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:70,right: 25,bottom: 6),
                  child: TextField(
                    controller: controller,
                    style:Fonts.regular(18, Colors.black),
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: Fonts.regular(15, Colors.grey),
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
                  ],
                ),
                child:Icon(icon,size: 30,color: Colors.blue[900],)
              ),
            ),
          ],
        )
    );
  }



loginFunction() async{
  var data = {
    "email":_emailController.text,
    "password":_passwordController.text
  };
  var response = await _registrationController.loginHandler(jsonEncode(data));
  print(response);
  if(response['result']=='success'){
    customDialog("Signin Successful");
    //Get.offAll(()=>Dashboard());

  }else{
     customDialog(response['data']['error'].toString());
  }
}


validation(){
  if(_emailController.text==''){
    customDialog("Please enter your Email");
    return false;
  }else if(_passwordController.text==''){
    customDialog("Please enter your Password");
    return false;
  }else{
    return true;
  }
}

  customDialog(String text){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Login"),
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