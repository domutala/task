import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task/components/task.dart';
import 'package:task/interfaces/ITask.dart';
import 'package:task/store/index.dart';
import 'package:task/store/task.dart';
import 'package:task/utils/colors.dart';
import 'package:task/utils/showModalBottom.dart';
import 'package:intl/intl.dart' as intl;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Colored.theme,
      darkTheme: Colored.themeDark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ITask> _tasks = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Store.init();
    finder();
  }

  finder() {
    _timer?.cancel();

    setState(() {
      _timer = Timer.periodic(const Duration(microseconds: 100), (timer) async {
        var tasks = await StoreTask.getAll();
        setState(() => _tasks = tasks);
      });
    });
  }

  openOption(ITask task) {
    Widget button({required String text, Widget? icon, Function()? onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerLeft,
          color: Theme.of(context).primaryColorLight,
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.only(right: 10),
                child: icon,
              ),
              Expanded(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    showModalBottom(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(
            onTap: () {
              Navigator.of(context).pop();
              showModalBottom(
                context: context,
                child: Task(id: task.id),
              );
            },
            text: 'Modifier',
            icon: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark.withOpacity(.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Icon(
                  Icons.edit,
                  size: 24,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
          ),
          button(
            onTap: () {
              StoreTask.remove(task.id);
              Navigator.of(context).pop();
            },
            text: 'Supprimer',
            icon: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark.withOpacity(.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Icon(
                  Icons.delete,
                  size: 24,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        // app bar
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness,

        // bottom navigation
        systemNavigationBarColor: Theme.of(context).primaryColorLight,
        systemNavigationBarIconBrightness: Theme.of(context).brightness,
        systemNavigationBarDividerColor: Theme.of(context).primaryColorLight,
      ),
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 160,
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 30),
              color: Colored.darken(Theme.of(context).primaryColorLight, .03),
              child: SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/calendar.svg',
                      color: Theme.of(context).primaryColorDark,
                      width: 56,
                    ),
                    Positioned(
                      top: 24,
                      right: -3,
                      child: Container(
                        height: 14,
                        width: 14,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: _tasks.isEmpty
                          ? Container(
                              margin: const EdgeInsets.only(top: 160),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/svg/calendar.svg',
                                  color: Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(.3),
                                  width: 86,
                                ),
                              ),
                            )
                          : null,
                    ),
                    for (var task in _tasks)
                      GestureDetector(
                        onTap: () {
                          showModalBottom(
                            context: context,
                            child: Task(id: task.id),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 13),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.05),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 15),
                                child: Icon(
                                  Icons.timer,
                                  color: Theme.of(context).primaryColorDark,
                                  size: 28,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      intl.DateFormat('dd MMMM yyyy')
                                          .format(task.datetime),
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                    Text(
                                      task.title,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    Container(
                                      child: task.description != null &&
                                              task.description!.isNotEmpty
                                          ? Text(
                                              task.description!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  openOption(task);
                                },
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    Icons.more_vert_rounded,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: SizedBox(
              width: 50,
              height: 50,
              child: TextButton(
                onPressed: () {
                  showModalBottom(context: context, child: const Task());
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  alignment: Alignment.center,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColorLight.withOpacity(.3)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColorLight),
                ),
                child: const Icon(Icons.add_rounded, size: 28),
              ),
            ),
          )
        ],
      ),
    );
  }
}
