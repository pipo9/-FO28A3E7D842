import 'package:flutter/material.dart';
import '../const.dart';
import 'horizontal_calendar/date_helper.dart';
import 'horizontal_calendar/horizontal_calendar.dart';

class CustomizedCalendar extends StatefulWidget {
  final onDateSelected;
  final double width;
  final double height;

  const CustomizedCalendar(
      {Key key,  this.onDateSelected,  this.width,  this.height})
      : super(key: key);

  @override
  _CustomizedCalendarState createState() => _CustomizedCalendarState();
}

class _CustomizedCalendarState extends State<CustomizedCalendar> {
   ScrollController _controller;

  @override
  void initState() {
      _controller =
        ScrollController(initialScrollOffset: 50.0 * 33);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HorizontalCalendar(
      key: Key('Calendar'),
      labelOrder: [
        LabelType.weekday,
        LabelType.date,
        LabelType.month,
      ],
      spacingBetweenDates: 0,
      defaultDecoration: BoxDecoration(
        color: kColor,
      ),
      selectedDecoration: BoxDecoration(
        color: kColorRed,
      ),
      weekDayTextStyle: TextStyle(
        fontSize: widget.width * 0.03,
        color: Colors.white.withOpacity(0.8),
      ),
      monthTextStyle: TextStyle(
        fontSize: widget.width * 0.03,
        color: Colors.white.withOpacity(0.8),
      ),
      dateTextStyle: TextStyle(
        fontSize: widget.width * 0.05,
        color: Colors.white,
        fontWeight: FontWeight.bold
      ),
      height: widget.width * 0.2,
      padding: EdgeInsets.symmetric(horizontal: 18),
      firstDate: DateTime.now().subtract(new Duration(days: 30)),
      lastDate: DateTime.now().add(new Duration(days: 30)),
      initialSelectedDates: [DateTime.now()],
      maxSelectedDateCount: 1,
      scrollController: _controller,
      onDateSelected: widget.onDateSelected,
    );
  }
}
