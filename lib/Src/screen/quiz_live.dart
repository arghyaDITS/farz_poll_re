
import 'package:farz_poll_re/Src/controller/quiz_controller.dart';
import 'package:farz_poll_re/Src/controller/registrationController.dart';
import 'package:farz_poll_re/Src/fonts/fonts.dart';
import 'package:farz_poll_re/Src/screen/imageviewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';

class QuizLive extends StatefulWidget {
  @override
  _QuizLiveState createState() => _QuizLiveState();
}

class _QuizLiveState extends State<QuizLive> {
  QuizController _quizController = Get.put(QuizController());
  RegistrationController _registrationController = Get.put(RegistrationController());
  double width = 0.0;
  double height = 0.0;
  double statusBarHeight = 0.0;
  var data = [];
  var userWiseQuestionData = [];
  var results = [];
  Map<String,double> pieChartMap = {"wrong":0.0,"correct":0.0,};

  fetchPieChart() async{
     var response = await _quizController.fetchPieChartData({
       "event_id":_quizController.eventId.toInt(),
       "user_id":_registrationController.userId.toInt()
     });
     if(response['result']=='success'){
       print(_quizController.pieChartData);
       double correct = double.parse(_quizController.pieChartData['correct']); 
       double wrong = double.parse(_quizController.pieChartData['wrong']); 
      setState(() {
         pieChartMap = {"wrong":wrong,"correct":correct,};
         print(pieChartMap);
      });
     }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPieChart();
    userWiseQuestionData = _quizController.userWiseAnswer.value;
    data = _quizController.liveQuestions.value;
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _quizController.liveQuestions.value = [];
    _quizController.userWiseAnswer.value = [];
    _quizController.result.value = [];
    _quizController.eventId.value = 0;
  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          children:[
          pieChartWidget(),
          questionsModule(),
          ]
        ),
      ),
    );
  }
 
  Widget pieChartWidget(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 300,
        width: width,
        child:PieChart(dataMap:pieChartMap)
      ),
    );
  }


  Widget questionsModule(){
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context,index){
      if(testingQuestion(data[index]['question_id'].toString())==true){
        return resultModule(index);
      }else{
        return answerModule(index);
      }
    });
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
    return (width-150)*doubleValue/100;
  }


  customDialog(String text,Function function){
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
          child: Text("Confirm"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Text("No"),
        ),
      ],
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
         fetchPieChart();
          var response = await _quizController.fetchTodaysQuiz(eventId);
          if(response['result']=='success'){
             setState(() {
            data = _quizController.liveQuestions.value;
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

testingQuestion(String questionId){
  var value = false;
  for(int i = 0; i < userWiseQuestionData.length ; i++){
    if(userWiseQuestionData[i]['question_id']==questionId){
      value = true;
    }
  }
  return value;
}

  Widget answerModule(int index){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: width/1.1,
              // child: Padding(
              //   padding: EdgeInsets.only(top:20.0),
              //   child: Text(removeAllHtmlTags("${data[index]['question']}"),style: Fonts.bold(18, Colors.black),textAlign: TextAlign.start, ),
              // ),
              child: Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: HtmlWidget(
                  "${data[index]['question']}"
                ),
              ),
            ),
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
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context,index1){
              return (data[index]['answer_${returnString(index1)}']=='')
              ? Container()
              : Padding(
                padding: const EdgeInsets.only(left:20.0,bottom: 10,right: 20),
                child: Column(
                  children: [
                    InkWell(
                      onTap:() async{
                         var submitAnswer =  {
                             "question_id":data[index]['question_id'],
                             "user_id":_registrationController.userId.toInt(),
                             "answer":"answer_${returnString(index1)}",
                             "event_id": _quizController.eventId.toInt()
                         };
                        customDialog("Are you sure with this answer?", (){
                          postAnswer(submitAnswer,data[index]['event_id']);
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
                          SizedBox(width: 20,),
                          Container(
                            width: width/1.4,
                            child: Text(data[index]['answer_${returnString(index1)}'],style: Fonts.regular(18, Colors.black),),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12,),
                    Padding(
                      padding: const EdgeInsets.only(left:50.0),
                      child: Container(
                        width: width,
                        height:3,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


  Widget resultModule(int index){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: width/1.1,
              child: Padding(
                padding: const EdgeInsets.only(top:20.0),
                // child: Text(
                //   removeAllHtmlTags("${data[index]['question']}").replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''),
                //   style: Fonts.bold(18, Colors.black),textAlign: TextAlign.start,
                // ),
                child: HtmlWidget(
                  "${data[index]['question']}"
                ),
              ),
            ),
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
            SizedBox(height: 15.0),
            ListView.builder(
              // padding: EdgeInsets.zero,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context,index1){
              return (data[index]['answer_${returnString(index1)}']=='')
              ? Container()
              : Padding(
                padding: const EdgeInsets.only(left:20.0,bottom: 6,right: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          child: Text("${returnInt(data[index]['option_${returnString(index1)}_percentage'])} %",style: Fonts.regular(16, Colors.black),)),
                        SizedBox(width: 0,),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(data[index]['answer_${returnString(index1)}'],style: Fonts.regular(18, Colors.black),)),
                        )
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: (data[index]['correct_answer']=='answer_${returnString(index1)}')?Colors.greenAccent[400]:Colors.white,
                              borderRadius: BorderRadius.circular(100)
                            ),
                            child: Icon(
                              Icons.check,
                              size: 20,
                              color: Colors.white,
                            ),
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
              );
            }),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  returnInt(var value){
    var stringValue = value.toString();
    var x = stringValue.split('.');
    return x[0];
  }
}