import 'dart:async';
import 'dart:convert';
import 'package:farz_poll_re/Src/controller/registrationController.dart';
import 'package:farz_poll_re/Src/fonts/fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyScores extends StatefulWidget {

  String eventID;
  MyScores({Key? key, required this.eventID});

  @override
  State<MyScores> createState() => _MyScoresState();
}

class _MyScoresState extends State<MyScores> {

  RegistrationController _registrationController =
  Get.put(RegistrationController());
  final StreamController _streamController = StreamController();

  @override
  void initState() {
    super.initState();
    getMyScores();
  }

  Future<String> getMyScores() async {
    String url = 'https://farzacademy.com/farz-poll/api/userWiseReport';
    var res = await http.post(Uri.parse(url), body: {
      'event_id': widget.eventID,
      'user_id': _registrationController.userId.toString(),
    });
    if(res.statusCode == 200){
      var data = jsonDecode(res.body);
      _streamController.add(data);
      print(data);
    }
    return 'Success';
  }

  @override
  void dispose() {
    super.dispose();
    if(!_streamController.isClosed) _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('My Scores'),
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            var scores = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Total Scores: ',
                              style: TextStyle(fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            Text('${scores['total_score']}',
                              style: TextStyle(fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: scores['scores'].length,
                          itemBuilder: (context, index){
                            var data = scores['scores'][index];
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${data['EpisodName']}',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Text('Score: ${data['EpisodScore']}',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: data['submitted_answers'].length, //data = scores['scores'][index];
                                  itemBuilder: (context, int){
                                    var answers = data['submitted_answers'][int];
                                    return Column(
                                      children: [
                                        // Padding(
                                        //   padding: EdgeInsets.symmetric(vertical: 10),
                                        //   child: HtmlWidget(
                                        //       "${answers['question']}"
                                        //   ),
                                        // ),

                                        ListView.builder(
                                          physics: ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: 5,
                                          itemBuilder: (context,index1){
                                            return (answers['answer_${returnString(index1)}'] == null ) ? Container() : Padding(
                                              padding: EdgeInsets.symmetric(vertical: 4),
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: answers['answer_type']=='answer_${returnString(index1)}' ?
                                                  Colors.green.withOpacity(0.3) :
                                                  Colors.blue.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        if(answers['answer_${returnString(index1)}'] != null)
                                                        Expanded(
                                                          child: Container(
                                                              padding: EdgeInsets.only(right: 20),
                                                              child: Text(answers['answer_${returnString(index1)}'],style: Fonts.regular(16, Colors.black),)),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 6),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        if(answers['AnswerGivenByUser']=='answer_${returnString(index1)}')
                                                          Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                              // color: answers['AnswerGivenByUser']=='answer_${returnString(index1)}' ? Colors.greenAccent[400]: Colors.white,
                                                              color: answers['AnswerGivenByUser'] == answers['answer_type'] ? Colors.greenAccent[400]: Colors.red,
                                                              borderRadius: BorderRadius.circular(100),
                                                            ),
                                                            child: answers['AnswerGivenByUser']== answers['answer_type'] ? Icon(
                                                              Icons.check,
                                                              size: 20,
                                                              color: Colors.white,
                                                            ) : Icon(
                                                              Icons.cancel_outlined,
                                                              size: 20,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),

                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(thickness: 1);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
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
