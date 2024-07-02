import 'dart:convert';
import 'package:farz_poll_re/Src/controller/registrationController.dart';
import 'package:farz_poll_re/Src/fonts/fonts.dart';
import 'package:farz_poll_re/Src/screen/dashboard.dart';
import 'package:farz_poll_re/Src/screen/login.dart';
import 'package:farz_poll_re/Src/widgets/header_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final RegistrationController _registrationController =
      Get.put(RegistrationController());
  TextEditingController _signupEmailController = TextEditingController();
  TextEditingController _signupPasswordController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _countrySearchController = TextEditingController();
  TextEditingController _stateSearchController = TextEditingController();
  TextEditingController _citySearchController = TextEditingController();

  double width = 0.0;
  double height = 0.0;
  double statusBarHeight = 0.0;
  bool stateFetched = false;
  bool cityFetched = false;
  String country = "";
  String state = "";
  String city = "";
  String countryId = '';
  String stateId = '';
  String cityId = '';
  bool buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height - statusBarHeight;
    statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(width),
              // Text("Signup and Start Learning!",style: Fonts.regular(18, Colors.orange[700]!),),
              Container(
                height: height - 100 - 50 - 40 - 8 - 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    textFieldNew("Name", Icons.person, _userNameController),
                    // SizedBox(height: 3,),
                    textFieldNew("Email", Icons.email, _signupEmailController),
                    //   SizedBox(height: 3,),
                    textFieldNew("Phone Number", Icons.phone, _mobileController),
                    //   SizedBox(height: 3,),
                    select(0),
                    select(1),
                    select(2),
                    passFieldNew(
                        "Password", Icons.lock, _signupPasswordController),
                    passFieldNew("Confirm Password", Icons.lock,
                        _confirmPasswordController),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    buttonPressed = true;
                  });
                  if (validation() == true) {
                    signupFunction();
                  }
                },
                child: Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                      color: (buttonPressed) ? Colors.blue : Colors.blue[900],
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Sign up",
                      style: Fonts.bold(18, Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => Login());
                },
                child: Container(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                          style: Fonts.regular(
                            16,
                            Colors.black,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Login",
                        style: Fonts.regular(16, Colors.orange[700]!),
                      ),
                    ],
                  ),
                ),
              ),
              Footer(width)
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(
      String hint, IconData icon, TextEditingController controller) {
    return Container(
      width: width / 1.2,
      height: 50,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: width / 1.2,
              height: 30,
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
                padding:
                const EdgeInsets.only(left: 60, right: 10, bottom: 2),
                child: TextField(
                  controller: controller,
                  style: Fonts.regular(18, Colors.black),
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
            alignment: Alignment.centerLeft,
            child: Container(
                width: 45,
                height: 45,
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
              child: Icon(
                icon,
                size: 25,
                color: Colors.blue[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textFieldNew(
      String hint, IconData icon, TextEditingController controller) {
    return Container(
      width: width / 1.2,
      height: 30,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 2, color: Colors.blue[800]!))),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 25, bottom: 8),
        child: TextField(
          controller: controller,
          style: Fonts.regular(18, Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: Fonts.regular(15, Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget passFieldNew(
      String hint, IconData icon, TextEditingController controller) {
    return Container(
      width: width / 1.2,
      height: 30,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 2, color: Colors.blue[800]!))),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 25, bottom: 8),
        child: TextField(
          controller: controller,
          style: Fonts.regular(18, Colors.black),
          obscureText: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: Fonts.regular(15, Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget select(int index) {
    return InkWell(
      onTap: () {
        if (index == 0) {
          //   _registrationController.countrySearchResult.value = [];
          countrySearchBox();
        } else if (index == 1) {
          _registrationController.stateSearchResult.value = [];
          stateSearchBox();
        } else if (index == 2) {
          _registrationController.citySearchResult.value = [];
          citySearchBox();
        }
      },
      child: Container(
        width: width / 1.2,
        height: 30,
        decoration: BoxDecoration(
            // color: Colors.green[200],
            border:
                Border(bottom: BorderSide(width: 2, color: Colors.blue[800]!))),
        child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 25, bottom: 8),
            child: (index == 0)
                ? Text((country == '') ? "Select Country" : country,
                    style: Fonts.regular(
                        16, (country == '') ? Colors.grey[500]! : Colors.black))
                : (index == 1)
                  ? Text((state == '') ? "Select State" : state,
                      style: Fonts.regular(16,
                          (state == '') ? Colors.grey[500]! : Colors.black))
                  : Text((city == '') ? "Select City" : city,
                      style: Fonts.regular(16,
                          (city == '') ? Colors.grey[500]! : Colors.black)),
        ),
      ),
    );
  }

  Widget passField(
      String hint, IconData icon, TextEditingController controller) {
    return Container(
        width: width / 1.2,
        height: 50,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: width / 1.2,
                height: 30,
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
                  padding:
                      const EdgeInsets.only(left: 60, right: 25, bottom: 2),
                  child: TextField(
                    controller: controller,
                    style: Fonts.regular(18, Colors.black),
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
              alignment: Alignment.centerLeft,
              child: Container(
                  width: 45,
                  height: 45,
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
                child: Icon(
                  icon,
                  size: 25,
                  color: Colors.blue[900],
                ),
              ),
            ),
          ],
        ));
  }

  Widget countrySearch() {
    return InkWell(
      onTap: () {
        countrySearchBox();
      },
      child: Container(
        width: width / 1.2,
        height: 50,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                  padding: EdgeInsets.only(left: 60),
                  width: width / 1.2,
                  height: 30,
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
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    country == '' ? "Select Country" : country,
                    style: Fonts.regular(16, Colors.black),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 45,
                height: 45,
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
                child: Icon(
                  Icons.flag,
                  size: 30,
                  color: Colors.blue[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  countrySearchBox() {
    _registrationController.searchCountry('');
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                content: Container(
                    width: width,
                    height: height,
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          width: width / 1.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(54, 62, 147, 0.5),
                                offset: Offset(2, 8),
                                blurRadius: 25,
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (value) {
                              _registrationController.searchCountry(value);
                            },
                            controller: _countrySearchController,
                            decoration: InputDecoration(
                              hintText: "Search Country",
                              hintStyle: Fonts.regular(18, Colors.grey),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 15, right: 5),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Obx(() => Expanded(
                          child: Container(
                            child: ListView.builder(
                              itemCount: _registrationController
                                      .countrySearchResult.length,
                              itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () async {
                                        changeCountry(_registrationController
                                            .countrySearchResult[index]['name']
                                            .toString());
                                        countryId = '';
                                        print(_registrationController
                                            .countrySearchResult[index]);
                                        country = _registrationController
                                            .countrySearchResult[index]['name']
                                            .toString();
                                        countryId = _registrationController
                                            .countrySearchResult[index]
                                                ['country_id']
                                            .toString();
                                        var data = {'country_id': countryId};
                                        var res = await _registrationController
                                            .statePoulate(jsonEncode(data));
                                        _countrySearchController.text = '';

                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        _registrationController
                                            .countrySearchResult[index]['name']
                                            .toString(),
                                        style: Fonts.regular(18, Colors.black),
                                      ),
                                    );
                                  }),
                            )))
                      ],
                    )));
          });
        });
  }

  changeCountry(String text) {
    setState(() {
      country = text;
      _registrationController.stateSearchResult.value = [];
      _registrationController.citySearchResult.value = [];
      state = '';
      city = '';
    });
  }

  changeState(String text) {
    setState(() {
      state = text;
      _registrationController.citySearchResult.value = [];
      city = '';
    });
  }

  changeCity(String text) {
    setState(() {
      city = text;
    });
  }

  Widget stateSearch() {
    return InkWell(
      onTap: () {
        stateSearchBox();
      },
      child: Container(
        width: width / 1.2,
        height: 50,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                  padding: EdgeInsets.only(left: 60),
                  width: width / 1.2,
                  height: 30,
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
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      state == '' ? "Select State" : state,
                      style: Fonts.regular(16, Colors.black),
                    ),
                  )),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 45,
                height: 45,
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
                child: Icon(
                  Icons.flag,
                  size: 30,
                  color: Colors.blue[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  stateSearchBox() {
    _registrationController.searchState('');
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                content: Container(
                    width: width,
                    height: height,
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          width: width / 1.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(54, 62, 147, 0.5),
                                offset: Offset(2, 8),
                                blurRadius: 25,
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (value) {
                              _registrationController.searchState(value);
                            },
                            controller: _stateSearchController,
                            decoration: InputDecoration(
                              hintText: "Search State",
                              hintStyle: Fonts.regular(18, Colors.grey),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 15, right: 5),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Obx(() => Expanded(
                                child: Container(
                              child: ListView.builder(
                                  itemCount: _registrationController
                                      .stateSearchResult.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () async {
                                        changeState(_registrationController
                                            .stateSearchResult[index]['name']
                                            .toString());
                                        _stateSearchController.text = '';
                                        state = _registrationController
                                            .stateSearchResult[index]['name']
                                            .toString();
                                        stateId = _registrationController
                                            .stateSearchResult[index]['id']
                                            .toString();
                                        var data = {'state_id': stateId};
                                        var res = await _registrationController
                                            .cityPoulate(jsonEncode(data));
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        _registrationController
                                            .stateSearchResult[index]['name']
                                            .toString(),
                                        style: Fonts.regular(18, Colors.black),
                                      ),
                                    );
                                  }),
                            )))
                      ],
                    )));
          });
        });
  }

  Widget citySearch() {
    return InkWell(
      onTap: () {
        citySearchBox();
      },
      child: Container(
        width: width / 1.2,
        height: 50,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.only(left: 60),
                width: width / 1.2,
                height: 30,
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
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    city == '' ? "Select City" : city,
                    style: Fonts.regular(16, Colors.black),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 45,
                height: 45,
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
                child: Icon(
                  Icons.flag,
                  size: 30,
                  color: Colors.blue[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  citySearchBox() {
    _registrationController.searchCity('');
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                content: Container(
                    width: width,
                    height: height,
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          width: width / 1.2,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(54, 62, 147, 0.5),
                                  offset: Offset(2, 8),
                                  blurRadius: 25,
                                ),
                              ]),
                          child: TextField(
                            onChanged: (value) {
                              _registrationController.searchCity(value);
                            },
                            controller: _citySearchController,
                            decoration: InputDecoration(
                              hintText: "Search City",
                              hintStyle: Fonts.regular(18, Colors.grey),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 15, right: 5),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Obx(() => Expanded(
                                child: Container(
                              child: ListView.builder(
                                  itemCount: _registrationController
                                      .citySearchResult.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () async {
                                        print(city);
                                        changeCity(_registrationController
                                            .citySearchResult[index]['name']
                                            .toString());
                                        _citySearchController.text = '';
                                        city = _registrationController
                                            .citySearchResult[index]['name']
                                            .toString();
                                        cityId = _registrationController
                                            .citySearchResult[index]['id']
                                            .toString();
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        _registrationController
                                            .citySearchResult[index]['name']
                                            .toString(),
                                        style: Fonts.regular(18, Colors.black),
                                      ),
                                    );
                                  }),
                            )))
                      ],
                    )));
          });
        });
  }

  //// Country Dropbox ////

  // Widget countrySearch(){
  //   return Container(
  //      width: width/1.2,
  //             height: 50,
  //     child: Stack(
  //       children: [
  //         Align(
  //           alignment: Alignment.centerRight,
  //           child: Container(
  //                 padding:EdgeInsets.only(left:60),
  //                 width: width/1.2,
  //                 height: 30,
  //                 decoration: BoxDecoration(
  //                    color: Colors.white,
  //                     borderRadius: BorderRadius.circular(100),
  //                     boxShadow: [
  //                       BoxShadow(
  //                     color: Colors.grey,
  //                     offset: const Offset(
  //                       5.0,
  //                       5.0,
  //                     ),
  //                     blurRadius: 10.0,
  //                     spreadRadius: 2.0,
  //                   ),
  //                     ]
  //                 ),
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(right: 4.0, left: 0),
  //                   child: DropdownButton(
  //                     borderRadius: BorderRadius.circular(10),
  //                     hint: Text(
  //                         "Select Country",
  //                         style: Fonts.regular(16,Colors.black),
  //                       ),
  //                     value: country,
  //                     onChanged: (newValue) {
  //                       setState(() {
  //                           country = newValue.toString();
  //                            });

  //                     },
  //                     style: Fonts.regular(16,Colors.black),
  //                     icon: Container(
  //                       width: 25,
  //                       height: 25,
  //                       decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(10)),
  //                       child: Icon(Icons.arrow_drop_down),
  //                     ),
  //                     iconSize: 15,
  //                     isExpanded: true,
  //                     underline: SizedBox(),
  //                     items: _registrationController.country.map((valueItem) {
  //                       return DropdownMenuItem(
  //                         onTap: ()async{
  //                          // countryId='';
  //                           countryId = valueItem['country_id'].toString();
  //                           if(_registrationController.state==[]){
  //                             var data = {'country_id':valueItem['country_id']};
  //                           var res = await _registrationController.statePoulate(jsonEncode(data));
  //                           if(res == true){
  //                             setState(() {

  //                             stateFetched=true;
  //                             cityFetched=false;
  //                             state=null;
  //                             city=null;
  //                           });
  //                           }
  //                           }else{
  //                             state=null;
  //                             city=null;
  //                             _registrationController.state.value = [];
  //                             _registrationController.city.value = [];
  //                             var data = {'country_id':valueItem['country_id']};
  //                           var res = await _registrationController.statePoulate(jsonEncode(data));
  //                           if(res == true){
  //                             setState(() {
  //                             stateFetched=true;
  //                             cityFetched=false;
  //                             state=null;
  //                             city=null;
  //                           });
  //                           }
  //                           }
  //                         },
  //                         value: valueItem['name'].toString(),
  //                         child: Text(valueItem['name'])
  //                       );
  //                     }).toList(),
  //                   ),
  //                 )
  //               ),
  //         ),
  //         Align(
  //                   alignment:Alignment.centerLeft,
  //                   child: Container(
  //                     width: 45,
  //                     height: 45,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(100),
  //                       boxShadow: [
  //                         BoxShadow(
  //                       color: Colors.grey,
  //                       offset: const Offset(
  //                         5.0,
  //                         5.0,
  //                       ),
  //                       blurRadius: 10.0,
  //                       spreadRadius: 2.0,
  //                     ),
  //                       ]
  //                     ),
  //                     child:Icon(Icons.flag,size: 30,color: Colors.blue[900],)
  //                   ),
  //                 ),
  //       ],
  //     ),
  //   );
  // }

  /// Country DropBox

  Widget stateMenu() {
    return Container(
      width: width / 1.2,
      height: 50,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.only(left: 60),
              width: width / 1.2,
              height: 30,
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
                padding: const EdgeInsets.only(right: 4.0, left: 0),
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(10),
                  value: state,
                  hint: Text(
                    "Select State",
                    style: Fonts.regular(16, Colors.black),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      state = newValue.toString();
                    });
                  },
                  style: Fonts.regular(16, Colors.black),
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
                      onTap: () async {
                        //stateId='';
                        stateId = valueItem['id'].toString();
                        if (_registrationController.city == []) {
                          var data = {'state_id': valueItem['id']};
                          var res = await _registrationController
                              .cityPoulate(jsonEncode(data));
                          if (res == true) {
                            setState(() {
                              cityFetched = true;
                            });
                          }
                        } else {
                          //  city=null;
                          _registrationController.city.value = [];
                          var data = {'state_id': valueItem['id']};
                          var res = await _registrationController
                              .cityPoulate(jsonEncode(data));
                          if (res == true) {
                            setState(() {
                              cityFetched = true;
                            });
                          }
                        }
                      },
                      value: valueItem['name'].toString(),
                      child: Text(valueItem['name']),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 45,
              height: 45,
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
              child: Icon(
                Icons.flag,
                size: 30,
                color: Colors.blue[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cityMenu() {
    return Container(
      width: width / 1.2,
      height: 50,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.only(left: 60),
              width: width / 1.2,
              height: 30,
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
                padding: const EdgeInsets.only(right: 4.0, left: 0),
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(10),
                  value: city,
                  hint: Text(
                    "Select City",
                    style: Fonts.regular(16, Colors.black),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      city = newValue.toString();
                    });
                  },
                  style: Fonts.regular(16, Colors.black),
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
                        onTap: () async {
                          // cityId='';
                          cityId = valueItem['id'].toString();
                        },
                        value: valueItem['name'].toString(),
                        child: Text(valueItem['name']));
                  }).toList(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 45,
              height: 45,
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
              child: Icon(
                Icons.flag,
                size: 30,
                color: Colors.blue[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  signupFunction() async {
    var data = {
      "name": _userNameController.text,
      "email": _signupEmailController.text,
      "mobile_no": _mobileController.text,
      "country_id": countryId.toString(),
      "state_id": stateId.toString(),
      "city_id": cityId.toString(),
      "password": _signupPasswordController.text,
      "c_password": _confirmPasswordController.text
    };
    print(data);
    var response =
        await _registrationController.signupHandler(jsonEncode(data));
    if (response['result'] == 'success') {
      customDialog("Signup Successfull");
      Get.offAll(() => Dashboard());
    } else {
      customDialog(response['data'].toString());
    }
  }

  validation() {
    if (_userNameController.text == '') {
      customDialog("Please enter your Name");
      return false;
    } else if (_signupEmailController.text == '') {
      customDialog("Please enter your Email");
      return false;
    } else if (_mobileController.text == '') {
      customDialog("Please enter your Phone Number");
      return false;
    } else if (countryId == null || countryId == '') {
      customDialog("Please Select your Country");
      return false;
    } else if (stateId == null || stateId == '') {
      customDialog("Please Select your State");
      return false;
    } else if (cityId == null || cityId == '') {
      customDialog("Please Select your City");
      return false;
    } else if (_signupPasswordController.text == '') {
      customDialog("Please enter your Password");
      return false;
    } else if (_confirmPasswordController.text == '') {
      customDialog("Please enter Confirm Password Field");
      return false;
    } else {
      return true;
    }
  }

  customDialog(String text) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Signup"),
        content: Text(text),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              setState(() {
                buttonPressed = false;
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
