import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:todoick/db_helper.dart';
import 'package:todoick/screens/taskPage.dart';
import 'package:todoick/widgets.dart';
import 'package:todoick/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  bool inputVisible = false;
  late FocusNode textFocus;

  @override
  void initState() {
    textFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 32),
          color: Color(0xFFFDFDFD),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 32, bottom: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image(
                            width: 40,
                            height: 40,
                            image: AssetImage('assets/images/logo.png')),
                        Icon(FeatherIcons.settings)
                      ],
                    ),
                  ),
                  LimitedBox(
                      maxHeight: 800,
                      child: FutureBuilder<List<Task>>(
                        initialData: [],
                        future: _dbHelper.getTasks(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: (snapshot.data as dynamic).length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TaskPage(
                                                      task: (snapshot.data
                                                          as dynamic)[index],
                                                    ))).then(
                                            (value) => setState(() {}));
                                      },
                                      child: TaskCardWidget(
                                        id: (snapshot.data as dynamic)[index]
                                            .id,
                                        title: (snapshot.data as dynamic)[index]
                                            .title,
                                        desc: (snapshot.data as dynamic)[index]
                                                    .desc !=
                                                null
                                            ? (snapshot.data as dynamic)[index]
                                                .desc
                                            : "No description",
                                        // desc: (snapshot.data as dynamic)[index].desc
                                      ));
                                });
                          }
                          return new Container(
                            alignment: AlignmentDirectional.center,
                            child: new CircularProgressIndicator(),
                          );
                        },
                      )),
                  GestureDetector(
                    onTap: () {
                      // textFocus.requestFocus();
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Wrap(
                              children: [
                                Container(
                                    padding: MediaQuery.of(context).viewInsets,
                                    // alignment:
                                    //     AlignmentDirectional.bottomCenter,
                                    margin: EdgeInsets.only(bottom: 8),
                                    child: Container(
                                      // padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFEBECF0),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: TextField(
                                          autofocus: true,
                                          focusNode: textFocus,
                                          onSubmitted: (value) async {
                                            if (value != "") {
                                              DatabaseHelper _dbHelper =
                                                  DatabaseHelper();
                                              Task _newTask = Task(
                                                title: value,
                                              );
                                              await _dbHelper
                                                  .insertTask(_newTask);
                                              setState(() {});
                                            }
                                            inputVisible = false;
                                          },
                                          style: TextStyle(
                                              fontSize: 18,
                                              // fontWeight: FontWeight.bold,
                                              color: Color(0xFF211551)),
                                          decoration: InputDecoration(
                                              hintText: "Enter Category",
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: -8))),
                                    )),
                              ],
                            );
                          });
                      // inputVisible = true;
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFEBECF0),
                          borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FeatherIcons.plus),
                          Text("Add Category",
                              style: TextStyle(
                                  color: Color(0xFF1C1B1E),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Visibility(
              //   visible: inputVisible,
              //   child: Container(
              //       alignment: AlignmentDirectional.bottomCenter,
              //       margin: EdgeInsets.only(bottom: 8),
              //       child: Container(
              //         // padding: EdgeInsets.all(10),
              //         decoration: BoxDecoration(
              //             color: Color(0xFFEBECF0),
              //             borderRadius: BorderRadius.circular(6)),
              //         child: TextField(
              //             onSubmitted: (value) async {
              //               if (value != "") {
              //                 DatabaseHelper _dbHelper = DatabaseHelper();
              //                 Task _newTask = Task(
              //                   title: value,
              //                 );
              //                 await _dbHelper.insertTask(_newTask);
              //                 setState(() {});
              //               }
              //               inputVisible = false;
              //             },
              //             style: TextStyle(
              //                 fontSize: 18,
              //                 // fontWeight: FontWeight.bold,
              //                 color: Color(0xFF211551)),
              //             decoration: InputDecoration(
              //                 hintText: "Enter Category",
              //                 border: InputBorder.none,
              //                 contentPadding: EdgeInsets.symmetric(
              //                     horizontal: 16, vertical: -8))),
              //       )),
              // )
            ],
          )),
    ));
  }
}
