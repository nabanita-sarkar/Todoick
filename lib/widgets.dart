import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:todoick/db_helper.dart';

class TaskCardWidget extends StatefulWidget {
  final int id;
  final String title;
  final String desc;
  const TaskCardWidget(
      {Key? key, required this.id, required this.title, required this.desc})
      : super(key: key);

  @override
  _TaskCardWidgetState createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  int taskId = 0;
  @override
  void initState() {
    taskId = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 4),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      color: Color(0xFF1C1B1E),
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                FutureBuilder<int?>(
                    future: _dbHelper.getPendingTodoCount(taskId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if ((snapshot.data as dynamic) == 0) {
                          return Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Color(0xFFF3F3F5),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Icon(
                                FeatherIcons.check,
                                color: Color(0xFF9EA4AB),
                                size: 16,
                              ));
                        } else
                          return Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xFFF6F6F6),
                            ),
                            child: Center(
                                child: Text(
                              (snapshot.data as dynamic).toString(),
                              style: TextStyle(color: Color(0xFF868290)),
                            )),
                          );
                      }
                      return new Container(
                        alignment: AlignmentDirectional.center,
                      );
                    }),
              ],
            ),
          ],
        ));
  }
}

class TodoWidget extends StatelessWidget {
  const TodoWidget({Key? key, required this.text, required this.isDone})
      : super(key: key);
  final String text;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Container(
              width: 20,
              height: 20,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  color: isDone
                      ? Colors.blueGrey.shade900
                      : Colors.blueGrey.shade100,
                  // border: isDone
                  //     ? null
                  //     : Border.all(color: Color(0xFF7349FE), width: 1.5),
                  borderRadius: BorderRadius.circular(6)),
              child: Icon(
                FeatherIcons.check,
                color: isDone ? Colors.white : Colors.transparent,
                size: 16,
              )),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                  color: isDone ? Color(0xFF868290) : Color(0xFF211551),
                  fontSize: 16,
                  decoration: isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
          )
        ],
      ),
    );
  }
}
