import 'dart:async';
import 'package:farz_poll_re/Src/controller/eventController.dart';
import 'package:farz_poll_re/Src/controller/quiz_controller.dart';
import 'package:farz_poll_re/Src/controller/registrationController.dart';
import 'package:farz_poll_re/Src/fonts/fonts.dart';
import 'package:farz_poll_re/Src/screen/Episodes/episodeScreen.dart';
import 'package:farz_poll_re/Src/screen/login.dart';
import 'package:farz_poll_re/Src/screen/pusherSingleton.dart';
import 'package:farz_poll_re/Src/screen/quiz_past.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 // EventController _eventController = Get.put(EventController());
  QuizController _quizController = Get.put(QuizController());
  RegistrationController _registrationController =
      Get.put(RegistrationController());
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  double width = 0.0;
  double height = 0.0;
  double statusBarHeight = 0.0;
  int pageIndex = 0;
  bool navBar = false;
  bool vis = false;
  bool fetched = false;
  int colorIndex = 012;
  List<Map> tabs = [
    {"name": "Past", "state": true, "link": "Past Events"},
    {"name": "Live", "state": false, "link": "Live"},
    {"name": "Upcomming", "state": false, "link": "Upcomming Events"},
  ];

  late Timer _timer;

  fetch() async {
    // var res = await _eventController.fetchAll();
  //  var res = await _eventController.fetchLiveEvents();
    // _eventController.setupWebSocket();
    // if (res == true) {
    //   setState(() {
    //     fetched = true;
    //   });
    // }
  }

 // late pusher.Channel channel;
  @override
  void initState() {
    super.initState();
    fetch();
    _timer = Timer.periodic(Duration(seconds: 8), (timer) {
      fetch();
    });
    // _eventController.setupWebSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This ensures that the channel is initialized after the widget has been built.
      // channel = PusherSingleton().pusherClient.subscribe('voiceless-chair-14'); //channel name

      // channel.bind('farzPoll', (pusher.PusherEvent? event) {
      //   if (event != null) {
      //     // Handle the received event data
      //     print('Received event: ${event.data}');
      //   }
      // });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if(_timer.isActive) _timer.cancel();
  //  channel.unbind('farzPoll'); //event name
    // _eventController.disposeAll();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      key: _key,
      appBar: AppBar(
        actions: [
          // (pageIndex == 0 || pageIndex == 1 || pageIndex == 2) ? Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
          //   child: InkWell(
          //     onTap: () {
          //       fetch();
          //     },
          //     child: Container(
          //       child: Icon(Icons.refresh, size: 25, color: Colors.blue[900],),
          //     ),
          //   ),
          // ) : Container(),
        ],
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.blue[900],), // set your color here
          onPressed: () {
            _key.currentState!.openDrawer();
          },
        ),
      ),
      drawer: drawer(),
      backgroundColor: Colors.white,
      body: WillPopScope(onWillPop: backButton, child: mainBody()),
    );
  }

  Widget drawer() {
    return Container(
      height: height,
      width: width / 1.4,
      // color: Color.fromRGBO(72, 66, 245, 1),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Container(
            // width: width / 1.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          InkWell(
            onTap: (){
        //      Share.share('check out my this app of farz https://farzacademy.com/');
            },
            child: drawerContainer("Share App", Icons.share),
          ),
          // SizedBox(height: 20),
          // drawerContainer("Rating", Icons.star),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              _registrationController.emptyValue();
              Get.offAll(() => Login());
            },
            child: drawerContainer("Logout", Icons.lock),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Account'),
                    content: Text(
                      'Are you sure you want to delete your account?',
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Yes'),
                        onPressed: () {
                          deleteAccount();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: drawerContainer("Delete Account", Icons.delete_forever),
          ),
        ],
      ),
    );
  }

  Future<String> deleteAccount() async {
    String url = 'https://farzacademy.com/farz-poll/api/delete-account';
    var response = await http.post(Uri.parse(url), body: {
      'user_id': '${_registrationController.userId.value}'
    });
    if(response.statusCode == 200){
      _registrationController.emptyValue();
      Get.offAll(() => Login());
    } else {
      print('Server Error');
    }
    return 'Success';
  }

  Widget drawerContainer(String text, IconData icon) {
    return Container(
      // width: width / 1.9,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(100),
          topRight: Radius.circular(100),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              icon,
              // color: Color.fromRGBO(72, 66, 245, 1),
              size: 26,
            ),
          ),
          Text(
            text,
            // style: Fonts.bold(14, Color.fromRGBO(72, 66, 245, 1)),
          ),
        ],
      ),
    );
  }

  Future<bool> backButton() async {
    if (pageIndex == 3) {
      customDialog("Do you want to go Back?", () {
        setState(() {
          pageIndex = 0;
        });
      });
    } else if (pageIndex == 4) {
      customDialog("Do you want to go Back?", () {
        setState(() {
          pageIndex = 1;
        });
      });
    } else {
      customDialog("Do you want to Logout?", () {
        _registrationController.emptyValue();
        Get.offAll(() => Login());
      });
    }
    return true;
  }

  Widget mainBody() {
    return Container(
      width: width,
      height: height,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              color: Colors.grey[300],
              // child: fetched == false ? Center(
              //   child: CircularProgressIndicator(),
              // ) : events(),
              child: Text("")
              //liveEvents(_eventController.liveEvents),
            ),
          ),
          // Container(
          //   width: width,
          //   height: 70,
          //   color: Colors.white,
          //   child: customTabs(),
          // ),
        ],
      ),
    );
  }

  Widget customTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: tabs.map((e) {
        return Expanded(
          child: InkWell(
            onTap: () {
              tabSwitch(e['name']);
              var index = tabs.indexOf(e);
              setState(() {
                pageIndex = index;
              });
            },
            child: Container(
              height: 70,
              child: Column(
                children: [
                  Container(
                    height: 4,
                    color: e['state'] ? Color.fromRGBO(222, 60, 0, 1)
                        : Colors.white,
                  ),
                  SizedBox(height: 7),
                  Container(
                    width: 32,
                    height: 32,
                    child: Image.asset('assets/images/icon1.png'),
                  ),
                  SizedBox(height: 4),
                  Text(
                    e['name'],
                    style: Fonts.regular(13, Colors.black),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  tabSwitch(String name) {
    for (int i = 0; i < tabs.length; i++) {
      if (tabs[i]['name'] == name) {
        tabs[i]['state'] = true;
      } else {
        tabs[i]['state'] = false;
      }
      setState(() {});
    }
  }

  Widget pastEvents(var data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Container(
            width: width,
            height: width / 2.3,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  width: width / 3,
                  height: width / 3,
                  child: Image.network(
                    data[index]['image'],
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: width / 1.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  height: 19,
                                  width: 19,
                                  child: Image.asset('assets/images/icon2.png'),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  data[index]['start_date'],
                                  style: Fonts.regular(10, Colors.black),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 6),
                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  height: 19,
                                  width: 19,
                                  child: Image.asset('assets/images/icon3.png'),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "${timeFunction(data[index]['start_time'])}-${timeFunction(data[index]['end_time'])}",
                                  style: Fonts.regular(10, Colors.black),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.only(right: 13.0),
                        child: Text(
                          data[index]['description'],
                          style: Fonts.regular(15, Colors.black),
                          textAlign: TextAlign.center,
                          maxLines: 5,
                        ),
                      ),
                      SizedBox(height: 7),
                      InkWell(
                        onTap: () async {
                          changeColor(index);
                          var response = await _quizController
                              .fetchPastQuestionAndResult(
                                  data[index]['id'].toString());
                          if (response['result'] == "success") {
                            setState(() {
                              pageIndex = 3;
                              colorIndex = 012;
                            });
                          } else {
                            customDialog(response['result'], () {});
                            setState(() {
                              colorIndex = 012;
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          decoration: BoxDecoration(
                            color: (colorIndex == index) ? Colors.blue
                                  : Color.fromRGBO(72, 66, 245, 1),
                            borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              "View Result",
                              style: Fonts.regular(15, Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  changeColor(int index) {
    setState(() {
      colorIndex = index;
    });
  }

  Widget liveEvents(var data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(data[index]['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: width / 1.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  height: 19,
                                  width: 19,
                                  child: Image.asset('assets/images/icon2.png'),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  data[index]['start_date'],
                                  style: Fonts.regular(10, Colors.black),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 6),
                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  height: 19,
                                  width: 19,
                                  child: Image.asset('assets/images/icon3.png'),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "${timeFunction(data[index]['start_time'])}-${timeFunction(data[index]['end_time'])}",
                                  style: Fonts.regular(10, Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.only(right: 13.0),
                        child: Text(
                          data[index]['description'],
                          style: Fonts.regular(15, Colors.black),
                          textAlign: TextAlign.center,
                          maxLines: 5,
                        ),
                      ),
                      SizedBox(height: 7),
                      InkWell(
                        onTap: () async {
                          // _quizController.liveQuestions.value = [];
                          // _quizController.userWiseAnswer.value = [];
                          // _quizController.result.value = [];
                          // var response = await _quizController
                          //     .fetchTodaysQuiz(data[index]['id']);
                          // if (response['result'] == "success") {
                          //   int eventId =
                          //       int.parse(data[index]['id'].toString());
                          //   var res = await _quizController
                          //       .fetchAnswerWiseQuestion({
                          //     "event_id": eventId,
                          //     "user_id":
                          //         _registrationController.userId.toInt()
                          //   });
                          //   if (res['result'] == 'success') {
                          //     setState(() {
                          //       print(eventId);
                          //       _quizController.eventId.value = eventId;
                          //       pageIndex = 4;
                          //     });
                          //   } else {
                          //     customDialog(response['result'], () {});
                          //   }
                          // } else {
                          //   customDialog(response['result'], () {});
                          // }
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EpisodeScreen(
                            eventID: '${data[index]['id']}',
                          )));
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(72, 66, 245, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text("Participate",
                              style: Fonts.regular(15, Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget upcomingEvent(var data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Container(
            width: width,
            // height: width / 2.5,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  width: width / 3,
                  height: width / 3,
                  child: Image.network(
                    data[index]['image'],
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: width / 1.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  height: 19,
                                  width: 19,
                                  child: Image.asset('assets/images/icon2.png'),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  data[index]['start_date'],
                                  style: Fonts.regular(10, Colors.black),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 6),
                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  height: 19,
                                  width: 19,
                                  child:
                                      Image.asset('assets/images/icon3.png'),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "${timeFunction(data[index]['start_time'])}-${timeFunction(data[index]['end_time'])}",
                                  style: Fonts.regular(10, Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 13),
                      Padding(
                        padding: const EdgeInsets.only(right: 13.0),
                        child: Text(
                          data[index]['description'],
                          style: Fonts.regular(15, Colors.black),
                          textAlign: TextAlign.center,
                          maxLines: 5,
                        ),
                      ),
                      SizedBox(height: 7),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  events() {
    // if (pageIndex == 0) {
    //   return pastEvents(_eventController.pastEvents);
    // } else if (pageIndex == 1) {
    //   return liveEvents(_eventController.liveEvents);
    // } else if (pageIndex == 2) {
    //   return upcomingEvent(_eventController.upcomingEvents);
    // } else if (pageIndex == 3) {
    //   return QuizPast();
    // } 
    // else if (pageIndex == 4) {
    //   return QuizLive();
    // }
  }

  customDialog(String text, Function function) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Message"),
        content: Text(text),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              function();
            },
            child: Text("okay"),
          ),
        ],
      ),
    );
  }

  timeFunction(String time) {
    var parsedTime = DateTime.parse("1974-03-20 $time");
    String ampm = '';
    int hour = 0;
    int minute = parsedTime.minute.toInt();
    if (parsedTime.hour >= 12) {
      hour = parsedTime.hour.toInt() - 12;
      ampm = 'PM';
    } else {
      hour = parsedTime.hour.toInt();
      ampm = 'AM';
    }
    return "$hour:$minute $ampm";
  }
}
