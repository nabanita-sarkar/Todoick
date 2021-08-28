import 'package:flutter/material.dart';
import 'package:gamma/db_helper.dart';
import 'package:gamma/screens/taskPage.dart';
import 'package:gamma/widgets.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 32, bottom: 32),
                    child: Image(image: AssetImage('assets/images/logo.png')),
                  ),
                  Expanded(
                      child: FutureBuilder<List<Task>>(
                    initialData: [],
                    future: _dbHelper.getTasks(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
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
                                                )))
                                        .then((value) => setState(() {}));
                                  },
                                  child: TaskCardWidget(
                                      title: (snapshot.data as dynamic)[index]
                                          .title,
                                      desc: (snapshot.data as dynamic)[index]
                                                .desc !=
                                            null
                                        ? (snapshot.data as dynamic)[index].desc
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
                  ))
                ],
              ),
              Positioned(
                height: 60,
                  width: 60,
                  bottom: 24,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskPage())).then((value) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                              begin: Alignment(0, -1),
                              end: Alignment(0, 1)),
                          borderRadius: BorderRadius.circular(50)),
                      child: Image(
                        image: AssetImage("assets/images/add_icon.png"),
                      ),
                    ),
                  ))
            ],
          )),
    ));
  }
}
