import 'package:cmsc128_lab/widgets/routineWidgets/task_selection_block.dart';
import 'package:flutter/material.dart';
import 'package:cmsc128_lab/utils/styles.dart';
import '../../utils/firestore_utils.dart';

class RoutineSessionList extends StatefulWidget {
  final String routineID;
  final Function _updateSelected;
  const RoutineSessionList(this.routineID, this._updateSelected, {super.key});

  @override
  State<RoutineSessionList> createState() => _RoutineSessionListState();
}

class _RoutineSessionListState extends State<RoutineSessionList> {
  late List activityIDs;
  FirestoreUtils dbService = FirestoreUtils();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _messagesListView();
  }

  Widget _messagesListView() {
    return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.80,
        width: MediaQuery.sizeOf(context).width,
        child: StreamBuilder(
            stream: dbService
                .getActivities(widget.routineID)
                .orderBy("order", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              List activities = snapshot.data?.docs ?? [];
              return ListView.separated(
                  itemBuilder: (context, index) {
                    var activity = activities[index].data();
                    if (activity.type == "activity") {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: StyleColor.tertiary,
                                padding: EdgeInsets.symmetric(horizontal: 20)),
                            child: ListTile(
                              leading: Icon(
                                  IconData(activity.icon,
                                      fontFamily: 'MaterialIcons'),
                                  color: Colors.white),
                              title: Text(activity.name,
                                  style: TextStyle(color: Colors.white)),
                              trailing: Text(
                                  _printDuration(
                                      Duration(seconds: activity.duration)),
                                  style: TextStyle(color: Colors.white)),
                            )),
                      );
                    } else {
                      return TaskSelectBlock(widget._updateSelected,
                          category: activity.category);
                    }
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: activities.length);
            }));
  }

  String _printDuration(Duration duration) {
    String twoDigitMinutes = duration.inMinutes.remainder(60).abs().toString();
    String twoDigitSeconds = duration.inSeconds.remainder(60).abs().toString();
    if (duration.inHours == 0) {
      return "$twoDigitMinutes min $twoDigitSeconds sec";
    } else {
      return "${duration.inHours} hr $twoDigitMinutes min";
    }
  }
}
