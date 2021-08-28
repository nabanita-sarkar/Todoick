import 'package:flutter/material.dart';
import 'package:gamma/db_helper.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                      color: Color(0xFF211551),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xFFF6F6F6),
                  ),
                  child: Center(
                    child: FutureBuilder<int>(
                        future: _dbHelper.getPendingTodoCount(taskId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              (snapshot.data as dynamic).toString(),
                              style: TextStyle(color: Color(0xFF868290)),
                            );
                          }
                          return new Container(
                            alignment: AlignmentDirectional.center,
                          );
                        }),
                  ),
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  widget.desc,
                  style: TextStyle(
                    fontStyle: widget.desc == "No description"
                          ? FontStyle.italic
                          : FontStyle.normal,
                      fontSize: 16, color: Color(0xFF868290), height: 1.5),
                ))
          ],
        ));
  }
}

class TodoWidget extends StatelessWidget {
  const TodoWidget({Key? key, required this.text, required this.isDone}) : super(key: key);
  final String text;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 8
      ),
      child: Row(
        children: [
          Container(
              width: 20,
              height: 20,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  color: isDone ? Color(0xFF7349FE) : Colors.transparent,
                  border: isDone ? null: Border.all(
                    color: Color(0xFF7349FE),
                    width: 1.5
                  ),
                  borderRadius: BorderRadius.circular(6)),
              child: 
                  Image(
                    image: AssetImage("assets/images/check_icon.png"),
                  )
               ),
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
