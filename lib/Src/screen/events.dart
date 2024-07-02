
import 'package:farz_poll_re/Src/controller/quiz_controller.dart';
import 'package:farz_poll_re/Src/screen/quiz_past.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Events extends StatefulWidget {
  final data;
  Events(this.data);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    QuizController _quizController = Get.put(QuizController());
    return Column(
      children: [
       ListView.builder(
         shrinkWrap: true,
         itemCount: widget.data.length,
         itemBuilder: (context,index){
           return ListTile(
             onTap: () async{
              var response = await _quizController.fetchTodaysQuiz(widget.data[index]['id']);
              if(response['result']=="success"){
                Get.to(()=>QuizPast());
              }else{
                customDialog(response['result']);
              }
             },
             leading: Image.network(widget.data[index]['image']),
             title: Text(widget.data[index]['title']),
             subtitle: Text(widget.data[index]['description']),       
           );
       })
      ],
    );
  }

  customDialog(String text){
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
            child: Text("okay"),
          ),
        ],
      ),
    );
  }
}