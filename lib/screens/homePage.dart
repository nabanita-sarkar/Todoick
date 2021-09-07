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
  bool colorEmojiPickerVisible = false;

  Color desc = Colors.blue;

  late FocusNode textFocus;
  int? currentTab = 0;
  final Map<int, Widget> tabs = const <int, Widget>{
    0: Text("Colors"),
    1: Text("Emoji")
  };


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
          padding: EdgeInsets.symmetric(horizontal: 24),
          color: Color(0xFFFDFDFD),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image(
                            width: 30,
                            height: 30,
                            image: AssetImage('assets/images/logo.png')),
                        Icon(FeatherIcons.settings)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(
                            FeatherIcons.calendar,
                            size: 20,
                          ),
                        ),
                        Text(
                          "Today",
                          style: TextStyle(
                              color: Color(0xFF1C1B1E),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
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
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(builder:
                                (BuildContext context,
                                    StateSetter setStateInside) {
                              return Wrap(
                                children: [
                                  Container(
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      margin: EdgeInsets.only(
                                          bottom: 8, left: 8, right: 8),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Focus(
                                                  onFocusChange: (focus) {
                                                    if (focus) {
                                                      colorEmojiPickerVisible =
                                                          false;
                                                    }
                                                  },
                                                  child: TextField(
                                                      cursorColor: Colors
                                                          .blueGrey.shade900,
                                                      autofocus: true,
                                                      focusNode: textFocus,
                                                      onSubmitted:
                                                          (value) async {
                                                        if (value != "") {
                                                          DatabaseHelper
                                                              _dbHelper =
                                                              DatabaseHelper();
                                                          Task _newTask = Task(
                                                              title: value,
                                                            desc: desc
                                                                  .toString()
                                                                  .split(
                                                                      '(0x')[1]
                                                                  .split(
                                                                      ')')[0]
                                                          );
                                                          await _dbHelper
                                                              .insertTask(
                                                                  _newTask);
                                                          setState(() {});
                                                        }
                                                        colorEmojiPickerVisible =
                                                            false;
                                                        inputVisible = false;
                                                      },
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.blueGrey
                                                              .shade900),
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  width: 0,
                                                                  style:
                                                                      BorderStyle
                                                                          .none,
                                                                ),
                                                              ),
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFFEBECF0),
                                                              hintText:
                                                                  "Enter Project",
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          4))),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  FocusScopeNode currentFocus =
                                                      FocusScope.of(context);
                                                  if (!currentFocus
                                                      .hasPrimaryFocus) {
                                                    currentFocus.unfocus();
                                                    setStateInside(() {
                                                      colorEmojiPickerVisible =
                                                          true;
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  width: 70,
                                                  margin:
                                                      EdgeInsets.only(left: 8),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 12),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFEBECF0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 16,
                                                        height: 16,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            border: Border.all(
                                                                color: desc,
                                                                width: 2)),
                                                      ),
                                                      Icon(FeatherIcons
                                                          .chevronDown)
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Visibility(
                                              visible: colorEmojiPickerVisible,
                                              child: Container(
                                                margin: EdgeInsets.only(top: 8),
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(8),
                                                            topRight:
                                                                Radius.circular(
                                                                    8))),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blueGrey
                                                              .shade100,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                currentTab = 0;
                                                                setStateInside(
                                                                    () {});
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            2),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                decoration: BoxDecoration(
                                                                    color: currentTab ==
                                                                            0
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .transparent,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                child:
                                                                    Container(
                                                                  child: Center(
                                                                    child: Text(
                                                                        "Colors"),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                currentTab = 1;
                                                                setStateInside(
                                                                    () {});
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            2),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                decoration: BoxDecoration(
                                                                    color: currentTab ==
                                                                            1
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .transparent,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                child:
                                                                    Container(
                                                                  child: Center(
                                                                    child: Text(
                                                                        "Emoji"),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 24),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              desc = Colors.red;
                                                              setStateInside(
                                                                  () {});
                                                            },
                                                            child: Container(
                                                              height: 24,
                                                              width: 24,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              desc =
                                                                  Colors.amber;
                                                              setStateInside(
                                                                  () {});
                                                            },
                                                            child: Container(
                                                              height: 24,
                                                              width: 24,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .amber,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              desc =
                                                                  Colors.cyan;
                                                              setStateInside(
                                                                  () {});
                                                            },
                                                            child: Container(
                                                              height: 24,
                                                              width: 24,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .cyan,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ))
                                        ],
                                      )),
                                ],
                              );
                            });
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
                          Text("Add Project",
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
            ],
          )),
    ));
  }
}
