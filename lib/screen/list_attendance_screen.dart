import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tomnenh/screen/card_attendance.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/build_card_dasboard.dart';
import 'package:tomnenh/widget/build_custom_appbar.dart';
import 'package:tomnenh/widget/card_custome.dart';

class ListAttendanceScreen extends StatelessWidget {
  ListAttendanceScreen({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ValueNotifier<DateTime> selectedDayNotifier =
      ValueNotifier(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: const BuildCustomAppbar(),
        body: Column(
          children: [
            buildTableCalendar(),
            buildRowMenu(),
            buildListAttendance()
          ],
        ));
  }

  Widget buildRowMenu() {
    return const CardCustom(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          BuildCardDasboard(
            icon: studentSvg,
            bgColor: mainColor,
            iconColor: mainColor,
            label: "Present",
            value: "70",
          ),
          BuildCardDasboard(
            icon: studentSvg,
            bgColor: redColor,
            iconColor: redColor,
            label: "Absent",
            value: "2",
          ),
        ],
      ),
    );
  }

  Widget buildListAttendance() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: 15,
          itemBuilder: (context, index) {
            return const CardAttendance();
          }),
    );
  }

  Widget buildTableCalendar() {
    return ValueListenableBuilder(
        valueListenable: selectedDayNotifier,
        builder: (context, result, child) {
          print("============result=====$result");
          return TableCalendar(
            headerVisible: true,
            daysOfWeekStyle: const DaysOfWeekStyle(
                decoration: BoxDecoration(color: whiteColor)),
            daysOfWeekHeight: 20,
            calendarFormat: CalendarFormat.week,
            weekendDays: const [DateTime.sunday],
            calendarStyle: const CalendarStyle(
                rowDecoration: BoxDecoration(
                  color: Colors.white,
                ),
                weekendTextStyle: TextStyle(color: Colors.red)),
            headerStyle: const HeaderStyle(
              headerMargin: EdgeInsets.only(bottom: 0),
              titleTextStyle: TextStyle(
                  color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
              decoration: BoxDecoration(color: whiteColor),
              formatButtonVisible: false,
              titleCentered: true,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              selectedDayNotifier.value = selectedDay;
            },
            selectedDayPredicate: (day) {
              return isSameDay(day, selectedDayNotifier.value);
            },
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
          );
        });
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double? y;
  final Color? color;
}
