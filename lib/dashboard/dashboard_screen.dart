import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tomnenh/screen/card_attendance.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/build_card_dasboard.dart';
import 'package:tomnenh/widget/build_custom_appbar.dart';
import 'package:tomnenh/widget/card_custome.dart';
import 'package:tomnenh/widget/text_widget.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ValueNotifier<DateTime> selectedDayNotifier =
      ValueNotifier(DateTime.now());
  final ValueNotifier<DateTime> selectedMonthNotifier =
      ValueNotifier(DateTime.now());

  String _getMonthName(int month) {
    return [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ][month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: const BuildCustomAppbar(),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          monthPicker(context),
          // buildTableCalendar(),
          buildRowMenu(),
          const SizedBox(height: 8),
          chartWidget(),
          attendanceRecently(),
          buildListAttendance()
        ],
      ),
    );
  }

  Widget monthPicker(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () async {
            DateTime? pickedMonth = await showMonthPicker(
              context: context,
              initialDate: selectedMonthNotifier.value,
              firstDate: DateTime(2010),
              lastDate: DateTime(2030),
            );
            if (pickedMonth != null) {
              selectedMonthNotifier.value = pickedMonth;
            }
          },
          child: ValueListenableBuilder<DateTime>(
            valueListenable: selectedMonthNotifier,
            builder: (context, selectedMonth, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text:
                        "${selectedMonth.year} - ${_getMonthName(selectedMonth.month)}",
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 24,
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  ListView buildListAttendance() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return const CardAttendance();
        });
  }

  Padding attendanceRecently() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: "Attendance Recently/(12-Mar-2025)",
          ),
          Row(
            children: [
              TextWidget(
                text: "More",
              ),
            ],
          )
        ],
      ),
    );
  }

  CardCustom chartWidget() {
    return CardCustom(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      horizontal: 16,
      vertical: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: "Attendance (Mar-2025)",
          ),
          Row(
            children: [
              Expanded(
                child: SfCircularChart(
                    margin: EdgeInsets.zero,
                    series: <CircularSeries>[
                      // Initialize line series
                      PieSeries<ChartData, String>(
                        dataSource: [
                          // Bind data source
                          ChartData('Present', 80, mainColor),
                          ChartData('Absent', 20, redColor),
                        ],
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        pointColorMapper: (ChartData data, _) => data.color,
                        // Render the data label
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                      ),
                    ]),
              ),
              Column(
                spacing: 8,
                children: [
                  buildRow(label: "Present", iconColor: mainColor),
                  buildRow(label: "Absent", iconColor: redColor),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  CardCustom buildRowMenu() {
    return const CardCustom(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          BuildCardDasboard(
            icon: studentSvg,
            iconColor: mainColor,
            bgColor: mainColor,
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

  Row buildRow({String label = "", Color iconColor = mainColor}) {
    return Row(
      spacing: 8,
      children: [
        Icon(
          Icons.circle,
          color: iconColor,
          size: 20,
        ),
        TextWidget(text: label),
      ],
    );
  }

  Widget buildTableCalendar() {
    return ValueListenableBuilder(
        valueListenable: selectedDayNotifier,
        builder: (context, result, child) {
          return TableCalendar(
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
