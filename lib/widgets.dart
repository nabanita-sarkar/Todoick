import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  const TaskCardWidget({Key? key, required this.title, required this.desc})
      : super(key: key);
  final String title;
  final String desc;

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
            Text(
              title,
              style: TextStyle(
                  color: Color(0xFF211551),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  desc,
                  style: TextStyle(
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
          Text(text, style: TextStyle(
            color: isDone ? Color(0xFF868290) : Color(0xFF211551),
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),)
        ],
      ),
    );
  }
}
