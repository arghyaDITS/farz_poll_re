
import 'package:farz_poll_re/Src/controller/quiz_controller.dart';
import 'package:farz_poll_re/Src/fonts/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizPast extends StatefulWidget {
  @override
  _QuizPastState createState() => _QuizPastState();
}

class _QuizPastState extends State<QuizPast> {
  QuizController _quizController = Get.put(QuizController());
  double width = 0.0;
  double height = 0.0;
  double statusBarHeight = 0.0;
  var data = [];


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _quizController.pastQuestions.value = [];
  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children:[
          Expanded(
            child: Container(
              child: questionsModule1(),
            ),
          ),
        ]
      ),
    );
  }


  Widget questionsModule(){
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: _quizController.pastQuestions.length,
      itemBuilder: (context,index){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical:10.0),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Container(
              //   width: width/1.1,
              //   child: Padding(
              //     padding: const EdgeInsets.only(top:20.0),
              //     // child: Text("${_quizController.pastQuestions[index]['question']}",
              //     //   style: Fonts.bold(18, Colors.black),textAlign: TextAlign.start,
              //     // ),
              //     child: HtmlWidget(
              //       "${_quizController.pastQuestions[index]['question']}"
              //     ),
              //   ),
              // ),
              SizedBox(height: 10,),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context,index1){
                return (_quizController.pastQuestions[index]['answer_${returnString(index1)}']=='')
                ? Container()
                : Padding(
                  padding: const EdgeInsets.only(left:20.0,bottom: 6,right: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            size: 30,
                            color: (_quizController.pastQuestions[index]['correct_answer']=='answer_${returnString(index1)}')?Colors.greenAccent[400]:Colors.white,),
                          SizedBox(width: 20,),
                          Container(
                            width: width/1.4,
                            child: Text(_quizController.pastQuestions[index]['answer_${returnString(index1)}'],style: Fonts.regular(18, Colors.black),))
                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            child: Text("${_quizController.pastQuestions[index]['option_${returnString(index1)}_percentage']} %",style: Fonts.regular(18, Colors.black),)),
                          SizedBox(width: 20,),
                          Container(
                            height: 4,
                            width: returnPercent(_quizController.pastQuestions[index]['option_${returnString(index1)}_percentage']),
                          //  width: returnPercent("100"),
                            color:(_quizController.pastQuestions[index]['correct_answer']=='answer_${returnString(index1)}')?Colors.greenAccent[400]:Colors.red,
                          )
                        ],
                      )
                    ],
                  ),
                );
              }),
              SizedBox(height: 20,)
            ],
          ),
        ),
      );
    });
  }

    Widget questionsModule1(){
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: _quizController.pastQuestions.length,
      itemBuilder: (context, index){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical:10.0),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Container(
              //   width: width/1.1,
              //   child: Padding(
              //     padding: const EdgeInsets.only(top:20.0),
              //     // child: Text("${_quizController.pastQuestions[index]['question']}",
              //     //   style: Fonts.bold(18, Colors.black),textAlign: TextAlign.start,
              //     // ),
              //     child: HtmlWidget(
              //       "${_quizController.pastQuestions[index]['question']}"
              //     ),
              //   ),
              // ),
              SizedBox(height: 25,),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context,index1){
                return (_quizController.pastQuestions[index]['answer_${returnString(index1)}']=='')
                ? Container()
                : Padding(
                  padding: const EdgeInsets.only(left:20.0,bottom: 6,right: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            child: Text("${returnInt(_quizController.pastQuestions[index]['option_${returnString(index1)}_percentage'])} %",style: Fonts.regular(16, Colors.black),)),
                          SizedBox(width: 0,),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(_quizController.pastQuestions[index]['answer_${returnString(index1)}'],style: Fonts.regular(18, Colors.black),)),
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
                                color: (_quizController.pastQuestions[index]['correct_answer']=='answer_${returnString(index1)}')?Colors.greenAccent[400]:Colors.white,
                                borderRadius: BorderRadius.circular(100)
                              ),
                              child: Icon(
                                Icons.check,
                                size: 20,
                                color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            height: 4,
                            width: returnPercent(_quizController.pastQuestions[index]['option_${returnString(index1)}_percentage']),
                            color:(_quizController.pastQuestions[index]['correct_answer']=='answer_${returnString(index1)}')?Colors.greenAccent[400]:Colors.red,
                          )
                        ],
                      ),
                      SizedBox(
                        height:15,
                      ),
                    Container(
                      height: 2,
                      width: width/1.2,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10,)
                    ],
                  ),
                );
              }),
              SizedBox(height: 20,)
            ],
          ),
        ),
      );
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

  returnInt(var value){
    var stringValue = value.toString();
    var x = stringValue.split('.');
    return x[0];
  }

}