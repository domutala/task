// ignore_for_file: file_names

import 'package:flutter/material.dart';

showModalBottom({
  required BuildContext context,
  required Widget child,
  Color? backgrounColor,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    enableDrag: false,
    barrierColor: Theme.of(context).primaryColorDark.withOpacity(.2),
    backgroundColor: Colors.transparent,
    elevation: 50,
    builder: (context) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Container(
          width: double.infinity,
          color: backgrounColor ?? Theme.of(context).primaryColorLight,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: child,
          ),
        ),
      );
    },
  );
}
