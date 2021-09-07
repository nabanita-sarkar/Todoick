import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:todoick/db_helper.dart';
import 'package:todoick/models/task.dart';
import 'package:todoick/models/todo.dart';
import 'package:todoick/widgets.dart';
import 'dart:developer' as devLog;

class TaskPage extends StatefulWidget {
  final Task? task;
  const TaskPage({Key? key, this.task}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  int? taskId = 0;
  String _taskTitle = "";
  String _taskDesc = "";

  late FocusNode titleFocus;
  late FocusNode descFocus;
  late FocusNode todoFocus;

  @override
  void initState() {
    if (widget.task != null) {
      taskId = widget.task!.id;
      _taskTitle = widget.task!.title;
      if (widget.task!.desc != null) {
        _taskDesc = (widget.task as dynamic).desc;
      }
    }
    titleFocus = FocusNode();
    descFocus = FocusNode();
    todoFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    titleFocus.dispose();
    descFocus.dispose();
    todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      child: Stack(children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16, left: 24, right: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    focusNode: titleFocus,
                    cursorColor: Color(0xFF7349FE),
                    onSubmitted: (value) async {
                      if (value != "") {
                        if (widget.task == null) {
                          DatabaseHelper _dbHelper = DatabaseHelper();
                          Task _newTask = Task(
                            title: value,
                          );
                          taskId = await _dbHelper.insertTask(_newTask);
                          setState(() {
                            _taskTitle = value;
                          });
                        } else {
                          await _dbHelper.updateTaskTitle(taskId, value);
                        }
                        todoFocus.requestFocus();
                      }
                    },
                    controller: TextEditingController()..text = _taskTitle,
                    decoration: InputDecoration(
                      hintText: "Task Title",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF211551)),
                  )),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Icon(FeatherIcons.x),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //     padding: EdgeInsets.only(bottom: 12),
            //     child: TextField(
            //       focusNode: descFocus,
            //       onSubmitted: (value) async {
            //         if (value != "") {
            //           await _dbHelper.updateTaskDesc(taskId, value);
            //         }
            //         todoFocus.requestFocus();
            //       },
            //       cursorColor: Color(0xFF7349FE),
            //       controller: TextEditingController()..text = _taskDesc,
            //       style: TextStyle(
            //           fontSize: 18,
            //           // fontWeight: FontWeight.bold,
            //           color: Color(0xFF211551)),
            //       decoration: InputDecoration(
            //           hintText: "Enter description for the task ...",
            //           border: InputBorder.none,
            //           contentPadding: EdgeInsets.symmetric(horizontal: 24)),
            //     )),
            // TodoWidget(text: "Todo", isDone: true),
            Expanded(
                child: FutureBuilder<List<Todo>>(
              initialData: [],
              future: _dbHelper.getTodos(taskId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: (snapshot.data as dynamic).length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () async {
                              if ((snapshot.data as dynamic)[index].isDone ==
                                  0) {
                                await _dbHelper.updateTodoDone(
                                    (snapshot.data as dynamic)[index].id, 1);
                              } else {
                                await _dbHelper.updateTodoDone(
                                    (snapshot.data as dynamic)[index].id, 0);
                              }
                              setState(() {});
                            },
                            child: TodoWidget(
                              text: (snapshot.data as dynamic)[index].title,
                              isDone:
                                  (snapshot.data as dynamic)[index].isDone == 0
                                      ? false
                                      : true,
                              // desc: (snapshot.data as dynamic)[index].desc
                            ));
                      });
                }
                return new Container(
                  alignment: AlignmentDirectional.center,
                );
              },
            )),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              margin: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      focusNode: todoFocus,
                      cursorColor: Colors.blueGrey.shade900,
                      controller: TextEditingController()..text = "",
                      onSubmitted: (value) async {
                        if (value != "") {
                          if (taskId != 0) {
                            Todo _newTodo =
                                Todo(taskId: taskId, title: value, isDone: 0);
                            await _dbHelper.insertTodo(_newTodo);
                            setState(() {
                              todoFocus.requestFocus();
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xFFEBECF0),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          hintText: "Todo "),
                    ),
                  ),
                  Container(
                    width: 70,
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                        color: Color(0xFFEBECF0),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.blue, width: 2)),
                        ),
                        Icon(FeatherIcons.chevronDown)
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ]),
    )));
  }
}
