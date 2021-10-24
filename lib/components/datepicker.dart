import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class DatepickerController extends ChangeNotifier {
  DateTime date;
  DatepickerController({required this.date});

  setValue(DateTime value) {
    date = value;
    notifyListeners();
  }
}

class Datepicker extends StatefulWidget {
  final DatepickerController datepickerController;

  const Datepicker({
    Key? key,
    required this.datepickerController,
  }) : super(key: key);

  @override
  State<Datepicker> createState() => _DatepickerState();
}

class _DatepickerState extends State<Datepicker> {
  int _currentMonth = 2;
  int _currentYear = 2021;

  @override
  void initState() {
    super.initState();
    init();
  }

  int get firstDayInMonth {
    return DateTime(_currentYear, _currentMonth, 1).weekday;
  }

  int get daysInMonth {
    DateTime date = DateTime(_currentYear, _currentMonth, 1);

    int nextMonth = date.month == 12 ? 1 : date.month + 1;
    int nextYear = _currentMonth == 12 ? date.year + 1 : date.year;
    DateTime nextDate = DateTime(nextYear, nextMonth, 1);

    var inter = nextDate.difference(date);

    return inter.inDays;
  }

  List<String> get weekDays {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    var days = List.generate(7, (index) => index)
        .map((value) => intl.DateFormat(intl.DateFormat.WEEKDAY)
            .format(firstDayOfWeek.add(Duration(days: value))))
        .toList();

    return days;
  }

  DateTime get currentDate {
    return DateTime(_currentYear, _currentMonth, 1);
  }

  List<TextButton> get wWeekDays {
    List<TextButton> days = [];

    for (var day in weekDays) {
      days.add(TextButton(
        onPressed: () {},
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          alignment: Alignment.center,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          foregroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).primaryColorDark),
        ),
        child: Text(day[0].toUpperCase()),
      ));
    }

    return days;
  }

  void next() {
    setState(() {
      _currentYear = _currentMonth == 12 ? _currentYear + 1 : _currentYear;
      _currentMonth = _currentMonth == 12 ? 1 : _currentMonth + 1;
    });
  }

  void prev() {
    setState(() {
      _currentYear = _currentMonth == 1 ? _currentYear - 1 : _currentYear;
      _currentMonth = _currentMonth == 1 ? 12 : _currentMonth - 1;
    });
  }

  String parseMonth(int month) {
    return intl.DateFormat(intl.DateFormat.MONTH)
        .format(DateTime(_currentMonth, month));
  }

  Widget wDay(int day) {
    DateTime date = DateTime(_currentYear, _currentMonth, day);
    DateTime now = DateTime.now();
    bool isNow =
        now.day == date.day && now.month == date.month && now.year == date.year;

    return TextButton(
      onPressed: () {
        widget.datepickerController.setValue(
          DateTime(_currentYear, _currentMonth, day),
        );
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        alignment: Alignment.center,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        overlayColor: MaterialStateProperty.all<Color>(
            Theme.of(context).primaryColorDark.withOpacity(.3)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        foregroundColor: MaterialStateProperty.all(isNow
            ? Theme.of(context).primaryColorDark
            : Theme.of(context).primaryColorDark),
      ),
      child: Text('$day'),
    );
  }

  init() async {
    DateTime now = DateTime.now();

    setState(() {
      _currentMonth = now.month;
      _currentYear = now.year;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).primaryColorDark.withOpacity(.03),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 80,
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: TextButton(
                  onPressed: prev,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    alignment: Alignment.center,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    overlayColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColorDark.withOpacity(.5)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColorDark),
                  ),
                  child: const Icon(Icons.chevron_left_rounded),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${parseMonth(currentDate.month)} ${currentDate.year}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 24,
                      height: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: TextButton(
                  onPressed: next,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    alignment: Alignment.center,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    overlayColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColorDark.withOpacity(.5)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColorDark),
                  ),
                  child: const Icon(Icons.chevron_right_rounded),
                ),
              ),
            ],
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          crossAxisCount: 7,
          childAspectRatio: 1,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          children: <Widget>[
            ...wWeekDays,
            for (var i = 0; i < firstDayInMonth - 1; i++)
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  alignment: Alignment.center,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColorDark),
                ),
                child: const Text(''),
              ),
            for (var i = 0; i < daysInMonth; i++) wDay(i + 1),
          ],
        ),
      ],
    );
  }
}
