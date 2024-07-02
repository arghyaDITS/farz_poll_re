import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeadershipBoard extends StatefulWidget {

  String eventID;
  LeadershipBoard({Key? key, required this.eventID});

  @override
  State<LeadershipBoard> createState() => _LeadershipBoardState();
}

class _LeadershipBoardState extends State<LeadershipBoard> {

  final StreamController _streamController = StreamController();

  @override
  void initState() {
    super.initState();
    getEventScore();
  }

  Future<String> getEventScore() async {
    String url = 'https://farzacademy.com/farz-poll/api/getEventScores';
    var res = await http.post(Uri.parse(url), body: {
      'event_id': widget.eventID,
    });
    if(res.statusCode == 200){
      var data = jsonDecode(res.body);
      _streamController.add(data['participants']);
      // print(data['participants']);
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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Leadership Board'),
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            var score = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset('assets/images/second.png', height: 40),
                              SizedBox(height: 5),
                              Text(score.length > 1 ? '${score[1]['user_name']}' : ''),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset('assets/images/first.png', height: 80),
                              SizedBox(height: 5),
                              Text(score.length > 0 ? '${score[0]['user_name']}' : ''),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset('assets/images/third.png', height: 40),
                              SizedBox(height: 5),
                              Text(score.length > 2 ? '${score[2]['user_name']}' : '',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Text('Score Listing',
                            style: TextStyle(fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                        score.isNotEmpty ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Student',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text('Score',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              itemCount: score.length,
                              itemBuilder: (context, index){
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${index + 1}'),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${score[index]['user_name']}'),
                                          Wrap(
                                            spacing: 8.0, // Adjust the spacing as needed
                                            children: score[index]['scores'].map<Widget>((ss) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text('${ss['EpisodName']}: '),
                                                    Text('${ss['EpisodScore']}'),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text('${score[index]['total_score']}'),
                                  ],
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return Divider(thickness: 1);
                              },
                            ),
                          ],
                        ) : Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('No One has participated yet'),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator(),);
        }
      ),
    );
  }
}
