import 'dart:async';
import 'dart:convert';
import 'package:farz_poll_re/Src/controller/quiz_controller.dart';
import 'package:farz_poll_re/Src/controller/registrationController.dart';
import 'package:farz_poll_re/Src/fonts/fonts.dart';
import 'package:farz_poll_re/Src/screen/Episodes/episodeQuestion.dart';
import 'package:farz_poll_re/Src/screen/Episodes/leadershipBoard.dart';
import 'package:farz_poll_re/Src/screen/Episodes/myScores.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EpisodeScreen extends StatefulWidget {

  String eventID;
  EpisodeScreen({Key? key, required this.eventID});

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {

  QuizController _quizController = Get.put(QuizController());
  RegistrationController _registrationController =
  Get.put(RegistrationController());

  final StreamController _streamController = StreamController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    getEpisodes();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getEpisodes();
    });
  }

  Future<String> getEpisodes() async {
    String url = 'https://farzacademy.com/farz-poll/api/eventwiseepisod';
    var res = await http.post(Uri.parse(url), body: {
      'event_id': widget.eventID,
    });
    if(res.statusCode == 200){
      var data = jsonDecode(res.body);
      // if (!_streamController.isClosed) {
        _streamController.add(data['episodsList']);
      // }
    }
    return 'Success';
  }

  @override
  void dispose() {
    super.dispose();
    if(_timer.isActive) _timer.cancel();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text('Episodes', style: Theme.of(context).appBarTheme.titleTextStyle,),
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            var episodes = snapshot.data;
            // print(episodes);
            return SingleChildScrollView(
              child: Column(
                children: [
                  episodes.isNotEmpty ? ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    itemCount: episodes.length,
                    itemBuilder: (context, index){
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text('${episodes[index]['episodename']}')),
                            // IconButton(
                            //   onPressed: (){
                            //     Navigator.push(context, MaterialPageRoute(builder: (context) => LeadershipBoard()));
                            //   },
                            //   icon: Icon(Icons.receipt_long_outlined),
                            // ),
                            // SizedBox(width: 10),
                            episodes[index]['status'] != 0 ?
                            InkWell(
                              onTap: () async {
                                // episodId
                                // _quizController.liveQuestions.value = [];
                                // _quizController.userWiseAnswer.value = [];
                                // _quizController.result.value = [];
                                // var response = await _quizController
                                //     .fetchLiveQuizNew(event_id: widget.eventID, episodeID: '${episodes[index]['id']}');
                                // if (response['result'] == "success") {
                                //   int eventId = int.parse(episodes[index]['id'].toString());
                                //   var res = await _quizController.fetchAnswerWiseQuestion({
                                //     "event_id": eventId,
                                //     "user_id": _registrationController.userId.toInt()
                                //   });
                                //   if (res['result'] == 'success') {
                                //     setState(() {
                                //       print(eventId);
                                //       _quizController.eventId.value = eventId;
                                //       // pageIndex = 4;
                                //       Navigator.push(context, MaterialPageRoute(builder: (context) => QuizLive()));
                                //     });
                                //   } else {
                                //     customDialog(response['result'], () {});
                                //   }
                                // } else {
                                //   customDialog(response['result'], () {});
                                // }
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EpisodeQuestion(
                                  eventID: widget.eventID, episodeID: '${episodes[index]['id']}',
                                )));
                              },
                              child: Container(
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(72, 66, 245, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text("Participate",
                                    style: Fonts.regular(15, Colors.white),
                                  ),
                                ),
                              ),
                            ) : InkWell(
                              onTap: () async {

                              },
                              child: Container(
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(145, 136, 136, 1.0),
                                  borderRadius: BorderRadius.circular(10),
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
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 10);
                    },
                  ) : Center(
                    child: Text('No Episode Available',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 80),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MaterialButton(
            height: 50,
            color: Colors.blue.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyScores(
                eventID: widget.eventID,
              )));
            },
            child: Row(
              children: [
                Icon(Icons.receipt_long_outlined, color: Colors.amber,),
                SizedBox(width: 5),
                Text('My Score'),
              ],
            ),
          ),
          SizedBox(width: 10),
          MaterialButton(
            height: 50,
            color: Colors.blue.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LeadershipBoard(
                eventID: widget.eventID,
              )));
            },
            child: Row(
              children: [
                // Icon(Icons.receipt_long_outlined),
                Image.asset('assets/images/first.png', height: 20,),
                SizedBox(width: 10),
                Text('Score Board'),
              ],
            ),
          ),
        ],
      ),
    );
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
}
