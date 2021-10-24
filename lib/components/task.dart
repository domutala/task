import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task/components/datepicker.dart';
import 'package:task/components/input.dart';
import 'package:task/interfaces/ITask.dart';
import 'package:task/store/task.dart';
import 'package:task/utils/colors.dart';
import 'package:task/utils/showModalBottom.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uuid/uuid.dart';

class Task extends StatefulWidget {
  final String? id;
  const Task({Key? key, this.id}) : super(key: key);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  ITask _task = ITask(
    id: const Uuid().v1(),
    title: '',
    datetime: DateTime.now(),
  );
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.id != null) {
      var task = await StoreTask.getOne(widget.id!);

      setState(() => _task = task ?? _task);
      setState(() => _title.text = _task.title);
      setState(() => _description.text = _task.description ?? '');
    }

    _title.addListener(() {
      setState(() => _task.title = _title.text);
      save();
    });
    _description.addListener(() {
      setState(() => _task.description = _description.text);
      save();
    });
  }

  save() {
    if (_task.title.isNotEmpty) {
      StoreTask.save(_task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColorDark.withOpacity(.1),
              ),
            ),
          ),
          child: Input(
            controller: _title,
            hintText: 'Title',
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colored.darken(Theme.of(context).primaryColorDark, 1),
            ),
          ),
        ),
        Input(
          controller: _description,
          hintText: 'Description',
          maxLines: 10,
          keyboardType: TextInputType.multiline,
          textStyle: TextStyle(
            fontSize: 18,
            color: Colored.darken(Theme.of(context).primaryColorDark, 1),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              var _datepickerController = DatepickerController(
                date: DateTime.now(),
              );

              _datepickerController.addListener(() {
                setState(() {
                  _task.datetime = _datepickerController.date;
                });
                Navigator.of(context).pop();
                save();
              });

              showModalBottom(
                context: context,
                child: Datepicker(datepickerController: _datepickerController),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20)),
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
            child: Text(intl.DateFormat('dd MMMM yyyy').format(_task.datetime)),
          ),
        )
      ],
    );
  }
}
