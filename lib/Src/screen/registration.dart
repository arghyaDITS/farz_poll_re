import 'dart:convert';
import 'package:farz_poll_re/Src/controller/registrationController.dart';
import 'package:farz_poll_re/Src/fonts/fonts.dart';
import 'package:farz_poll_re/Src/screen/homePage.dart';
import 'package:farz_poll_re/Src/widgets/logo.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  const Registration({ Key? key }) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  final RegistrationController _registrationController = Get.put(RegistrationController());
  double width = 0.0;
  double height = 0.0;
  double statusBarHeight = 0.0;
  bool rememberMe = false;
  bool stateFetched = false;
  bool cityFetched = false;

  // dropbox

  String ?country;
  String ?state;
  String ?city;

  int pageIndex=0;

  // Log in 
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

 //  reset Password
  TextEditingController _forgotPassEmailController = TextEditingController();

 // Signup

  TextEditingController _signupEmailController = TextEditingController();
  TextEditingController _signupPasswordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _secondNameController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();


  countryPopulate()async{
   var res = await  _registrationController.countryPoulate();
   if(res==true){
     print("Country Fetched");
   } else{
     print("Api Fetched Error");
   }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countryPopulate();
  }


  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Column(
        children: [
          SizedBox(height: statusBarHeight,),
          SizedBox(height:60),
          Logo(width),
          SizedBox(height: 30,),
          registerBox()
        ],
      )
    );
  }

Widget registerBox(){
  return Expanded(
            child: Container(
              child: Center(
                child: Container(
                  width: width/1.08,
                  height: height-statusBarHeight-120,
                   decoration: BoxDecoration(
                     color: Colors.lightBlue[100],
                     borderRadius: BorderRadius.circular(10),
                   ),
                   child: Column(
                     children: [
                       Container(
                         width: width/1.08,
                         height: 80,
                         child: Center(child: heading()),
                       ),
                       Expanded(
                         child: Container(
                           child: (pageIndex==0)?login():(pageIndex==1)?signup():forgotPassword(),
                         ),
                       )
                     ],
                   )
                ),
              ),
            ),
          );
}

Widget login(){
  return SingleChildScrollView(
    child: Column(
                                 children: [
                                   textField(_emailController,Icons.email,"Email"),
                                   textField(_passwordController,Icons.vpn_key, "Password"),
                                  // rememberme(),
                                  SizedBox(height: 30,),
                                   InkWell(
                                     onTap: (){
                                       loginFunction();
                                     },
                                     child: button("Login",25)),
                                   SizedBox(height: 20,),
                                   InkWell(
                                     onTap: (){
                                       setState(() {
                                         pageIndex=3;
                                       });
                                     },
                                     child: Text("Forgot Password",style: Fonts.regular(20, Color.fromRGBO(14, 128, 121, 1)),)),
                                   SizedBox(
                                     height: 30,
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.symmetric(horizontal :20.0),
                                     child: Container(child: Text("By signing up, you agree to our Terms & Condition , Privacy Policy.",style: Fonts.regular(16, Colors.grey[800]!),textAlign: TextAlign.center,)),
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.symmetric(horizontal:15.0),
                                     child: Divider(
                                       height: 50,
                                       thickness: 2,
                                       color: Colors.grey[600],
                                     ),
                                   ),
                                   Text("Dont have account ?",style: Fonts.regular(17, Colors.grey[800]!),textAlign: TextAlign.center,),
                                   SizedBox(height: 15,),
                                   GestureDetector(
                                     onTap: (){
                                       setState(() {
                                         pageIndex=1;
                                         country=null;
                                         state=null;
                                         city=null;
                                         stateFetched=false;
                                         cityFetched=false;
                                       });
                                     },
                                     child: button("Signup",25)),
                                   SizedBox(height: 30,)
                                 ],
                               ),
  );
}

loginFunction() async{
  var data = {
    "email":_emailController.text,
    "password":_passwordController.text
  };
  var response = await _registrationController.loginHandler(jsonEncode(data));
  if(response['result']=='success'){
    Get.offAll(()=>Homepage());
  }else{
     customDialog(response['data']['error'].toString());
  }
}


Widget signup(){
  return SingleChildScrollView(
    child: Column(
                                 children: [
                                   textField(_firstNameController,Icons.person,"First Name"),
                                   textField(_secondNameController,Icons.person,"Second Name"),
                                   textField(_signupEmailController,Icons.email,"Email"),
                                   textField(_mobileController,Icons.phone,"Phone Number"),
                                   SizedBox(height:25),
                                   countryMenu(),
                                  (stateFetched)?SizedBox(height:25):Container(),
                                   (stateFetched)
                                   ?
                                   Column(
                                     children: [
                                       stateMenu(),
                                       (cityFetched)?SizedBox(height:25):Container()
                                     ],
                                   )
                                   :
                                   Container(),
                                   (cityFetched)
                                   ?
                                   Column(
                                     children: [
                                       cityMenu(),
                                       
                                     ],
                                   )
                                   :
                                   Container(),
                                   textField(_signupPasswordController,Icons.vpn_key,"Password"),
                                   textField(_confirmPasswordController,Icons.vpn_key,"Confirm Password"),
                                   SizedBox(height: 30,),
                                   InkWell(
                                     onTap: (){
                                       signupFunction();
                                     },
                                     child: button("Signup",25)),
                                   SizedBox(height: 30,),
                                   Text("Already have account ?",style: Fonts.regular(17, Colors.grey[800]!),textAlign: TextAlign.center,),
                                   Divider(

                                   ),
                                   GestureDetector(
                                     onTap: (){
                                       setState(() {
                                         pageIndex=0;
                                       });
                                     },
                                     child: Container(
                                   width: 250,
                                   height: 55,
                                   decoration: BoxDecoration(
                                     color: Color.fromRGBO(14, 128, 121, 1),
                                     borderRadius: BorderRadius.circular(10)
                                   ),
                                   child: Center(
                                     child: Text("Signin",style: Fonts.regular(25, Colors.white),),
                                   ),
                                 )),
                                   SizedBox(height: 30,)
                                 ],
                               ),
  );
}

signupFunction() async{
  var data = {
    "name":"${_firstNameController.text} ${_secondNameController.text}",
    "email": _signupEmailController.text,
    "mobile_no": _mobileController.text,
    "country_id": country,
    "state_id": state,
    "city_id": city,
    "password": _signupPasswordController.text,
    "c_password": _confirmPasswordController.text
  };
  var response = await _registrationController.signupHandler(jsonEncode(data));
  if(response['result']=='success'){
      customDialog("Signup Successfull");
  }else{
    customDialog(response['data'].toString());
  }
}

// Colors.lightBlue


Widget forgotPassword(){
  return Column(
                               children: [
                                 textField(_forgotPassEmailController,Icons.email,"Email"),
                                 SizedBox(
                                   height: 30,
                                 ),
                                 InkWell(
                                   onTap: (){
                                     forgetPassFunction();
                                   },
                                   child: button("Send Password in Email",16)),
                                 Expanded(child: SizedBox()),  
                                 Padding(
                                   padding: const EdgeInsets.symmetric(vertical:20.0),
                                   child: GestureDetector(
                                     onTap: (){
                                       setState(() {
                                         pageIndex=0;
                                       });
                                     },
                                     child: Container(
                                     width: 250,
                                     height: 55,
                                     decoration: BoxDecoration(
                                       color: Color.fromRGBO(14, 128, 121, 1),
                                       borderRadius: BorderRadius.circular(30)
                                     ),
                                     child: Center(
                                       child: Text("Signin",style: Fonts.regular(25, Colors.white),),
                                     ),
                                                                    ),
                                   ),
                                 )
                               ],
                             );
}


forgetPassFunction() async{
  var data = {
    "email": _forgotPassEmailController.text,
    };
  var response = await _registrationController.forgotPasswordHandler(jsonEncode(data));
  if(response['result']=='success'){
      customDialog(response['data']['success']);
  }else{
    customDialog(response['data']['error']['email'][0].toString());
  }
}
  
Widget textField(TextEditingController controller,IconData icon, String hint){
  return    Padding(
    padding: const EdgeInsets.only(top:30.0),
    child: Container(
                               width: width/1.2,
                               height: 50,
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 border: Border.all(width: 3,color: Colors.grey),
                                 borderRadius: BorderRadius.circular(30)
                               ),
                               child: Row(
                                 children: [
                                   Container(
                                     width: 50,
                                     height: 50,
                                     child: Center(
                                       child: Icon(icon,color: Colors.grey,),
                                     ),
                                   ),
                                   Expanded(
                                     child: Padding(
                                       padding: const EdgeInsets.symmetric(horizontal:8.0),
                                       child: Container(
                                        child: Center(child: 
                                        TextField(
                                          controller:controller,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintStyle: Fonts.regular(16, Colors.grey[600]!),
                                            hintText: hint),
                                        )),
                                       ),
                                     ),
                                   )
                                 ],
                               ),
                             ),
  );
}

Widget rememberme(){
  return        Padding(
                                   padding: const EdgeInsets.symmetric(vertical:25.0),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       InkWell(
                                         onTap: (){
                                           setState(() {
                                         rememberMe==true ? rememberMe = false : rememberMe = true;
                                       });
                                         },
                                         child: Container(
                                           width: 20,
                                           height: 20,
                                           decoration: BoxDecoration(
                                             color: rememberMe ? Colors.lightBlue: Colors.white,
                                             borderRadius: BorderRadius.circular(8),
                                             border: Border.all(width: 2,color: Colors.lightBlue)
                                           ),
                                           child: Center(
                                             child:rememberMe?Icon(Icons.check,color: Colors.white,size: 15,):Container()
                                           ),
                                         ),
                                       ),
                                       SizedBox(width: 15,),
                                       Text("Remember Me",style: Fonts.regular(20, Colors.grey[800]!),)
                                     ],
                                   ),
                                 );
}

Widget button(String text,double size){
  return Container(
                                   width: 250,
                                   height: 55,
                                   decoration: BoxDecoration(
                                     color: Color.fromRGBO(14, 128, 121, 1),
                                     borderRadius: BorderRadius.circular(30)
                                   ),
                                   child: Center(
                                     child: Text(text,style: Fonts.regular(size, Colors.white),),
                                   ),
                                 );
}

  Widget countryMenu(){
    return Container(
          width: width/1.2,
          height: 50,
          decoration: BoxDecoration(
           color: Colors.white,
           border: Border.all(width: 3,color: Colors.grey),
           borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0, left: 12),
            child: DropdownButton(
              borderRadius: BorderRadius.circular(10),
              hint: Text(
                  "Select Country",
                  style: Fonts.regular(18,Colors.black),
                ),
              value: country,
              onChanged: (newValue) {
                setState(() {
                    country = newValue.toString();
                     });

              },
              style: Fonts.regular(18,Colors.black),
              icon: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.arrow_drop_down),
              ),
              iconSize: 15,
              isExpanded: true,
              underline: SizedBox(),
              items: _registrationController.country.map((valueItem) {
                return DropdownMenuItem(
                  onTap: ()async{
                    if(_registrationController.state==[]){
                      var data = {'country_id':valueItem['country_id']};
                    var res = await _registrationController.statePoulate(jsonEncode(data));
                    if(res == true){
                      setState(() {
                      stateFetched=true;
                      cityFetched=false;
                      state=null;
                      city=null;
                    });
                    }
                    }else{
                      state=null;
                      city=null;
                      _registrationController.state.value = [];
                      _registrationController.city.value = [];
                      var data = {'country_id':valueItem['country_id']};
                    var res = await _registrationController.statePoulate(jsonEncode(data));
                    if(res == true){
                      setState(() {
                      stateFetched=true;
                      cityFetched=false;
                      state=null;
                      city=null;
                    });
                    }
                    }
                  },
                  value: valueItem['name'].toString(),
                  child: Text(valueItem['name'])
                );
              }).toList(),
            ),
          )
        );
  }

   Widget stateMenu(){
    return Container(
          width: width/1.2,
          height: 50,
          decoration: BoxDecoration(
           color: Colors.white,
           border: Border.all(width: 3,color: Colors.grey),
           borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0, left: 12),
            child: DropdownButton(
              borderRadius: BorderRadius.circular(10),
              value: state,
              hint: Text(
                  "Select State",
                  style: Fonts.regular(18,Colors.black),
                ),
              onChanged: (newValue) {
                setState(() {
                    state = newValue.toString();
                     });
              },
              style: Fonts.regular(18,Colors.black),
              icon: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.arrow_drop_down),
              ),
              iconSize: 15,
              isExpanded: true,
              underline: SizedBox(),
              items: _registrationController.state.map((valueItem) {
                return DropdownMenuItem(
                  onTap: () async{
                    if(_registrationController.city==[]){
                      var data = {'state_id':valueItem['id']};
                    var res = await _registrationController.cityPoulate(jsonEncode(data));
                    if(res==true){
                      setState(() {
                      cityFetched=true;
                    });
                    }
                    }else{
                      city=null;
                      _registrationController.city.value=[];
                      var data = {'state_id':valueItem['id']};
                    var res = await _registrationController.cityPoulate(jsonEncode(data));
                    if(res==true){
                      setState(() {
                      cityFetched=true;
                    });
                    }
                    }
                  },
                  value: valueItem['name'].toString(),
                  child: Text(valueItem['name'])
                );
              }).toList(),
            ),
          )
        );
  }

   Widget cityMenu(){
    return Container(
          width: width/1.2,
          height: 50,
          decoration: BoxDecoration(
           color: Colors.white,
           border: Border.all(width: 3,color: Colors.grey),
           borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0, left: 12),
            child: DropdownButton(
              borderRadius: BorderRadius.circular(10),
              value: city,
              hint: Text(
                  "Select City",
                  style: Fonts.regular(18,Colors.black),
                ),
              onChanged: (newValue) {
                setState(() {
                    city = newValue.toString();
                     });
              },
              style: Fonts.regular(18,Colors.black),
              icon: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.arrow_drop_down),
              ),
              iconSize: 15,
              isExpanded: true,
              underline: SizedBox(),
              items: _registrationController.city.map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem['name'].toString(),
                  child: Text(valueItem['name'])
                );
              }).toList(),
            ),
          )
        );
  }

heading(){
 if(pageIndex==0){
   return  Text("Login",style: Fonts.bold(32, Color.fromRGBO(14, 128, 121, 1)),);
 }else if(pageIndex==1){
   return Text("Signup and Start Learning!",style: Fonts.bold(26, Color.fromRGBO(14, 128, 121, 1)),);
 }else{
   return Text("Forget Password?",style: Fonts.bold(32, Color.fromRGBO(14, 128, 121, 1)),);
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
                        Navigator.of(ctx).pop();
                      },
                      child: Text("okay"),
                    ),
                  ],
                ),
              );
}

}