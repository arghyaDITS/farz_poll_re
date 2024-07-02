
import 'package:farz_poll_re/Src/controller/eventController.dart';
import 'package:farz_poll_re/Src/fonts/fonts.dart';
import 'package:farz_poll_re/Src/screen/events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  EventController _eventController = Get.put(EventController());
  double width = 0.0;
  double height = 0.0;
  double statusBarHeight = 0.0;
  int pageIndex = 0;
  bool fetched= false;
  List<Map> tabs = [
    {
      "name":"Past",
      "state":true,
      "link":"Past Events"
    },
    {
      "name":"Live",
      "state":false,
      "link":"Live"
    },
    {
      "name":"Upcomming",
      "state":false,
      "link":"Upcomming Events"
    },
  ];
  fetch()async {
    var res = await _eventController.fetchAll();
    if(res==true){
      setState(() {
        fetched=true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        title: Text("Events", style: Fonts.bold(25, Colors.white)),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue[100],
      body: Column(
        children: [
          customTabs(),
          fetched==false ?
          Expanded(child: Container(child:Center(child: CircularProgressIndicator(),)))
          : Expanded(
            child:Container(
              child: events(),
            ),
          ),
        ],
      )
    );
  }


  Widget customTabs(){
    return Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children:  tabs.map((e){
         return Expanded(
         child: InkWell(
           onTap: (){
             tabSwitch(e['name']);
              var index = tabs.indexOf(e);
             setState(() {
               pageIndex=index;
             });
           },
           child: Container(
             height:50,
             color: e['state']?Colors.blue[900]:Colors.blue,
             child: Center(child: Text(e['name'],style: Fonts.bold(15,e['state']?Colors.white:Colors.black),)),
           ),
         ),
       );
       }
       ).toList(),
    );
  }

  tabSwitch(String name){
    for(int i = 0 ; i < tabs.length ; i++){
       if(tabs[i]['name']==name){
         tabs[i]['state']=true;
       }else{
         tabs[i]['state']=false;
       }
       setState(() {
         
       });
    }
  }

  events(){
    if(pageIndex==0){
      return Events(_eventController.pastEvents);
    }else if(pageIndex==1){
      return Events(_eventController.liveEvents);
    }else if(pageIndex==2){
       return Events(_eventController.upcomingEvents);
    }
  }
}