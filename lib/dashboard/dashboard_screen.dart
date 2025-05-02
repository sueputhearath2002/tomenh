import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/screen/card_attendance.dart';
import 'package:tomnenh/screen/uploads/upload_cubit.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/build_card_dasboard.dart';
import 'package:tomnenh/widget/build_custom_appbar.dart';
import 'package:tomnenh/widget/card_custome.dart';
import 'package:tomnenh/widget/text_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final ValueNotifier<DateTime> selectedDayNotifier =
      ValueNotifier(DateTime.now());

  final ValueNotifier<DateTime> selectedMonthNotifier =
      ValueNotifier(DateTime.now());

  final ValueNotifier<bool> chartReady = ValueNotifier(false);

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
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      chartReady.value = true;
    });
    super.initState();
  }

  final screenCubit = UploadCubit();

  void filterAttendanceMonthStudentByAdmin() async {
    String formatted =
        DateFormat('yyyy-MM').format(selectedMonthNotifier.value);
    await screenCubit.filterAttendanceMonthStudentByAdmin(formatted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: const BuildCustomAppbar(),
      body: BlocBuilder<UploadCubit, UploadState>(
        bloc: screenCubit,
        builder: (context, state) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              monthPicker(context),
              // buildTableCalendar(),
              buildRowMenu(
                countTotal: state.totalStudent ?? 0,
                countAbsent: state.totalAbsent ?? 0,
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: chartReady,
                builder: (_, isReady, __) {
                  if (!isReady) {
                    return const SizedBox(
                        height: 200); // Or loading placeholder
                  }
                  return RepaintBoundary(
                    child: chartWidget(
                      countTotal: state.totalStudent ?? 0,
                      countAbsent: state.totalAbsent ?? 0,
                    ),
                  );
                },
              ),
              attendanceRecently(),
              buildListAttendance(state.students ?? [])
            ],
          );
        },
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
              filterAttendanceMonthStudentByAdmin();
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

  ListView buildListAttendance(List<Student> students) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: students.length,
        itemBuilder: (context, index) {
          return RepaintBoundary(
            child: CardAttendance(
              user: students[index],
            ),
          );
        });
  }

  Padding attendanceRecently() {
    String formatted =
        DateFormat('yyyy-MM').format(selectedMonthNotifier.value);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: "Attendance Recently  ($formatted)",
          ),
        ],
      ),
    );
  }

  CardCustom chartWidget({int countTotal = 0, int countAbsent = 0}) {
    String formatted =
        DateFormat('yyyy-MM').format(selectedMonthNotifier.value);
    return CardCustom(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      horizontal: 16,
      vertical: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: "Attendance ($formatted)",
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
                          ChartData(
                              'Students', countTotal.toDouble(), mainColor),
                          ChartData('Absent', countAbsent.toDouble(), redColor),
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

  CardCustom buildRowMenu({int countTotal = 0, int countAbsent = 0}) {
    return CardCustom(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          BuildCardDasboard(
            icon: studentSvg,
            iconColor: mainColor,
            bgColor: mainColor,
            label: "Students",
            value: countTotal.toString(),
          ),
          BuildCardDasboard(
            icon: studentSvg,
            bgColor: redColor,
            iconColor: redColor,
            label: "Absent",
            value: countAbsent.toString(),
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
