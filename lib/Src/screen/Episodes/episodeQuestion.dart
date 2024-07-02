import 'dart:async';
import 'dart:convert';
import 'package:farz_poll_re/Components/customDialogBox.dart';
import 'package:farz_poll_re/Src/controller/quiz_controller.dart';
import 'package:farz_poll_re/Src/controller/registrationController.dart';
import 'package:farz_poll_re/Src/screen/Episodes/leadershipBoard.dart';
import 'package:farz_poll_re/Src/screen/Episodes/myScores.dart';
import 'package:farz_poll_re/Src/screen/imageviewer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../fonts/fonts.dart';
import 'package:get/get.dart';

class EpisodeQuestion extends StatefulWidget {

  String eventID;
  String episodeID;
  EpisodeQuestion({Key? key, required this.eventID, required this.episodeID});

  @override
  State<EpisodeQuestion> createState() => _EpisodeQuestionState();
}

class _EpisodeQuestionState extends State<EpisodeQuestion> {

  QuizController _quizController = Get.put(QuizController());
  RegistrationController _registrationController = Get.put(RegistrationController());
  final StreamController _streamController = StreamController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    getQuestionsData();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      getQuestionsData();
    });
  }

  Future<String> getQuestionsData() async {
    String url = 'https://farzacademy.com/farz-poll/api/todays_question';
    var res = await http.post(Uri.parse(url), body: {
      'event_id': widget.eventID,
      'episodId': widget.episodeID,
      'user_id': _registrationController.userId.toString(),
    });
    if(res.statusCode == 200){
      var data = jsonDecode(res.body);
      _streamController.add(data['todays_question']);
    } else {
      print(widget.eventID);
      print(widget.episodeID);
    }
    return 'Success';
  }

  int selectedAnswer = 0;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
    _streamController.close();
  }

  returnString(int num){
    if(num==0){
      return "a";
    }else if(num==1){
      return "b";
    }else if(num==2){
      return "c";
    }else if(num==3){
      return "d";
    }else if(num==4){
      return "e";
    }
  }

  var userWiseQuestionData = [];
  testingQuestion(String questionId){
    var value = false;
    for(int i = 0; i < userWiseQuestionData.length ; i++){
      if(userWiseQuestionData[i]['question_id']==questionId){
        value = true;
      }
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        // title: Text('${widget.episodeID}'),
        actions: [
          // Text('$_start', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyScores(
                eventID: widget.eventID,
              )));
            },
            child: Text('My Score'),
          ),
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LeadershipBoard(
                eventID: widget.eventID,
              )));
            },
            child: Text('Score board'),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/quiz.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            StreamBuilder(
              stream: _streamController.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.hasData){
                  var data = snapshot.data;
                  return data.isNotEmpty ? ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // itemCount: data.length,
                    itemCount: 1,
                    itemBuilder: (context, index){
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            // Padding(
                            //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            //   child: HtmlWidget(
                            //       "${data[index]['question']}"
                            //   ),
                            // ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if(data[index]['image_one'] != '')
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewer(imageURL: '${data[index]['image_one']}')));
                                    },
                                    child: Image.network('${data[index]['image_one']}',
                                        width: MediaQuery.of(context).size.width*0.45),
                                  ),
                                if(data[index]['image_two'] != '')
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewer(imageURL: '${data[index]['image_two']}')));
                                    },
                                    child: Image.network('${data[index]['image_two']}',
                                        width: MediaQuery.of(context).size.width*0.45),
                                  ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if(data[index]['image_three'] != '')
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewer(imageURL: '${data[index]['image_three']}')));
                                    },
                                    child: Image.network('${data[index]['image_three']}',
                                        width: MediaQuery.of(context).size.width*0.45),
                                  ),
                                if(data[index]['image_four'] != '')
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewer(imageURL: '${data[index]['image_four']}')));
                                    },
                                    child: Image.network('${data[index]['image_four']}',
                                        width: MediaQuery.of(context).size.width*0.45),
                                  ),
                              ],
                            ),
                            SizedBox(height: 10),
                            data[index]['isAnswerSubmitted'] != true ?
                            ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context,index1){
                                return data[index]['answer_${returnString(index1)}'] == '' ? Container()
                                  : Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                              child: InkWell(
                                                onTap:() async{
                                                  var submitAnswer =  {
                                                    "question_id":data[index]['question_id'],
                                                    "user_id":_registrationController.userId.toInt(),
                                                    "answer":"answer_${returnString(index1)}",
                                                    "event_id": int.parse(widget.eventID),
                                                  };
                                                  customDialog(context, "Are you sure with this answer?", (){
                                                    postAnswer(submitAnswer,data[index]['event_id']);
                                                    getQuestionsData();
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    data[index]['answer_${returnString(index1)}']==data[index]['answer_${testingQuestion(data[index]['question_id'].toString())}']
                                                        ? Icon(
                                                      Icons.radio_button_checked,
                                                      size: 30,
                                                      color: Colors.black,
                                                    ) : Icon(
                                                      Icons.radio_button_off,
                                                      size: 30,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(child: Text(data[index]['answer_${returnString(index1)}'],style: Fonts.regular(16, Colors.black),)),
                                                  ],
                                                ),
                                              ),
                                      ),
                                    ),
                                  );
                              },
                            ) :
                            ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context,index1){
                                return (data[index]['answer_${returnString(index1)}']=='') ? Container() : Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              child: Text("${returnInt(data[index]['option_${returnString(index1)}_percentage'])} %",
                                                style: Fonts.regular(16, Colors.black),
                                              ),
                                            ),
                                            // SizedBox(width: 0),
                                            Expanded(
                                              child: Container(
                                                  padding: EdgeInsets.only(right: 20),
                                                  child: Text(data[index]['answer_${returnString(index1)}'],style: Fonts.regular(16, Colors.black),)),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            if(data[index]['correct_answer']=='answer_${returnString(index1)}')
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: data[index]['correct_answer']=='answer_${returnString(index1)}' ? Colors.greenAccent[400]: Colors.white,
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              height: 4,
                                              width: returnPercent(data[index]['option_${returnString(index1)}_percentage']),
                                              color:(data[index]['correct_answer']=='answer_${returnString(index1)}')?Colors.greenAccent[400]:Colors.red,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 10,);
                    },
                  ) : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('No Question available now',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator(),);
              }
            ),

          ],
        ),
      ),
    );
  }

  responseDialogue(String text){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Message"),
        content: Text(text),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  postAnswer(Map submitAnswer,var eventId) async{
    var response = await _quizController.submitAnswer(submitAnswer);
    if(response['result']=="success"){
      responseDialogue(response['data']['success'].toString());
      var res = await _quizController.fetchAnswerWiseQuestion(
          {
            "event_id":_quizController.eventId.toInt(),
            "user_id":_registrationController.userId.toInt()
          }
      );
      if(res['result']=="success"){
        var response = await _quizController.fetchTodaysQuiz(eventId);
        if(response['result']=='success'){
          setState(() {
            // data = _quizController.liveQuestions.value;
          });
        }
        setState(() {
          userWiseQuestionData=_quizController.userWiseAnswer.value;
          print(userWiseQuestionData);
        });
      }
    }else{
      responseDialogue(response['data']['success'].toString());
    }
  }

  returnPercent(String value){
    double doubleValue = double.parse(value);
    return (MediaQuery.of(context).size.width-150)*doubleValue/100;
  }

  returnInt(var value){
    var stringValue = value.toString();
    var x = stringValue.split('.');
    return x[0];
  }
}
