import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tomnenh/drawer/drawer.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/style/constant.dart';
import 'package:tomnenh/widget/circle_btn.dart';
import 'package:tomnenh/widget/container_custome.dart';

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double? y;
  final Color? color;
}

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final List<ChartData> chartData = [
    ChartData("Mon", 35, Colors.green),
    ChartData("Tue", 13, Colors.cyanAccent),
    ChartData("Wen", 34, Colors.amber),
    ChartData("Thur", 27, Colors.purple),
    ChartData("Fri", 40, Colors.blueAccent),
    ChartData("Sat", 40, Colors.deepOrange),
    ChartData("Sun", 60, Colors.pink),
  ];

  List<Map<String, dynamic>> componentsString = [
    {
      "icon": customerSvg,
      "title": "Product",
      "value": "70",
    },
    {
      "icon": customerSvg,
      "title": "Category",
      "value": "70",
    },
    {
      "icon": customerSvg,
      "title": "Supplier",
      "value": "70",
    },
    {
      "icon": customerSvg,
      "title": "Outgoing",
      "value": "70",
    },
    {
      "icon": customerSvg,
      "title": "Customer",
      "value": "70",
    },
    {
      "icon": customerSvg,
      "title": "Purchase",
      "value": "70",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const Drawer(
        child: DrawerPath(),
      ),
      appBar: AppBar(
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(70),
        //   ),
        // ),
        //backgroundColor: green50Color,
        centerTitle: false,
        titleSpacing: 8,
        title: const Row(
          children: [
            // CirCleBtn(
            //   onTap: () => _key.currentState!.openDrawer(),
            //   width: 30,
            //   height: 30,
            //   isRedNote: true,
            //   iconSvg: moreSvg,
            //   paddingIconSvg: 8,
            // ),
            Text(
              "Dashboard",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: CirCleBtn(
              width: 30,
              height: 30,
              isRedNote: true,
              iconSvg: bellSvg,
              paddingIconSvg: 8,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // decoration: BoxDecoration(
              //     color: browColor, borderRadius: BorderRadius.circular(8)),
              //: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 2.3,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                padding: EdgeInsets.zero,
                itemCount: componentsString.length,
                itemBuilder: (context, index) {
                  return ContainerCustom(
                      icon: componentsString[index]["icon"],
                      title: componentsString[index]["title"],
                      value: componentsString[index]["value"]);
                },
              ),
            ),
            gapH(8),
            const Text(
              "Graph ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            gapH(8),
            SfCartesianChart(
                // backgroundColor: green50Color,
                // borderColor: greenColor,
                primaryXAxis: const CategoryAxis(
                    isVisible: true,
                    labelStyle: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    arrangeByIndex: false,
                    majorGridLines: MajorGridLines(width: 0)),
                series: <CartesianSeries<dynamic, dynamic>>[
                  SplineSeries<ChartData, String>(
                    dataLabelSettings: const DataLabelSettings(
                        isVisible: true, color: greenColor),
                    enableTooltip: false,
                    dataSource: chartData,
                    color: greenColor,
                    //pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) =>
                        data.x, // Map the day as a string
                    yValueMapper: (ChartData data, _) =>
                        data.y, // Map the value as a double
                  ),
                ]),
            // Flexible(
            //   flex: 2,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       subContainerCus(
            //         icon: listSvg,
            //         containerColor: greenColor,
            //         title: "View all List items",
            //         subTitle:
            //             "Display each Items with its name \n description and attribute",
            //       ),
            //       subContainerCus(
            //         icon: phoneSvg,
            //         containerColor: green50Color,
            //         title: "Contact Customer",
            //         subTitle:
            //             "Provide each contact's name, phone number, \nemail address, and other relevant details.",
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [greenColor, green50Color],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            profile(),
            contentCustom(icon: product, title: "Set Up Product"),
            contentCustom(icon: unit, title: "Set up Unit"),
            contentCustom(icon: customer, title: "Set up Customer"),
            contentCustom(icon: place, title: "Store or sell place"),
            contentCustom(icon: status, title: "Set up status"),
            contentCustom(icon: logoutSvg, title: "Logout"),
          ],
        ),
      ),
    );
  }

  Widget contentCustom({String icon = "", String title = ""}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(icon),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(color: whiteColor),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: whiteColor,
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 0.5,
          color: whiteColor,
        ),
      ],
    );
  }

  Container profile() {
    return Container(
      color: greenColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.fill,
                      imageUrl:
                          "https://htmlstream.com/preview/unify-v2.6/assets/img-temp/400x450/img5.jpg",
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User Name",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: whiteColor),
                    ),
                    Text(
                      "Admin",
                      style: TextStyle(fontSize: 16, color: whiteColor),
                    )
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: whiteColor,
            )
          ],
        ),
      ),
    );
  }

  Widget subContainerCus({
    Color? containerColor,
    String? title,
    String? subTitle,
    String? icon,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: containerColor),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(icon ?? ""),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        title ?? "",
                        style: const TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subTitle ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: whiteColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
