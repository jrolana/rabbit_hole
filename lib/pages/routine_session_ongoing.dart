import 'package:cmsc128_lab/pages/routine_session_complete.dart';
import 'package:cmsc128_lab/pages/routine_session_timer.dart';
import 'package:cmsc128_lab/pages/routine_session_timer_tasks.dart';
import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/routine.dart';
import '../utils/firestore_utils.dart';

class RoutineSessionOngoing extends StatefulWidget {
  final String routineID;
  int actNum;
  final Map<String,dynamic> taskIDs;
  RoutineSessionOngoing(this.routineID, this.actNum, this.taskIDs,{super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StateRoutineSessionOngoing();
  }
}

class _StateRoutineSessionOngoing extends State<RoutineSessionOngoing> {
  FirestoreUtils db = FirestoreUtils();
  final PageController _pageViewController = PageController();
  @override
  void initState() {
    // TODO: implement initState
    getNumAct();
    super.initState();
  }
  void getNumAct() async {
    await db.getActivities(widget.routineID).get().then((snap){
      var acts = snap.docs;
      for(var x in acts){
        Activity data = x.data() as Activity;
        if(data.type == "taskblock"){
          if(!widget.taskIDs.containsKey(data.category)){
            widget.actNum -=1;
          }
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
        title: const Text('Routine Session'),
      ),
      body: StreamBuilder(
          stream: db.getActivities(widget.routineID).orderBy("order",descending: false).snapshots(),
          builder: (context, snapshot){
            List activities = snapshot.data?.docs ?? [];
            if(activities.isNotEmpty){
                return PageView.builder(
                  itemBuilder: (context, index) {
                    Activity act = activities[index].data();
                    if (act.type == "activity") {
                      return RoutineSessionTimer(
                          act.name, act.duration,
                          act.icon, index, _navigatePage);
                    }
                    if(widget.taskIDs.isNotEmpty){
                    return RoutineSessionTimerTasks(
                        act.category, act.duration, index, _navigatePage,
                        widget.taskIDs[act.category]);}
                    }
                  ,
                  controller: _pageViewController,
                  onPageChanged: _handlePageChange,
                  physics: const NeverScrollableScrollPhysics(),
                );
              }else{
              return Text("Getting Routine Data");
            }
          }
          ),
    );
  }

  void _handlePageChange(int currentPageIndex) {
    print('page changed');
  }

  void _navigatePage(int index) {
    print(widget.actNum);
    print(index);
    if (index == widget.actNum) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>RoutineSessionComplete(widget.routineID)));
      // TODO session complete
    } else {
      _pageViewController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutExpo,
      );
    }
  }
}

