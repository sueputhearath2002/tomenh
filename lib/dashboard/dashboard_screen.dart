import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tomnenh/drawer/drawer.dart';
import 'package:tomnenh/style/assets.dart';
import 'package:tomnenh/style/colors.dart';
import 'package:tomnenh/widget/circle_btn.dart';

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

  Map<String, dynamic> data = {
    "record": [
      {
        "group": "", // Group for the record
        "totalAmount": "",
        "items": [
          {
            "id": 626,
            "itemNo": "BEV-00019",
            "group": "", // Group for the item
            "description": "Hot Cappuccino - Medium",
            "description2": "",
            "quantity": 6.00,
            "unitPrice": "\$4.09",
            "subTotal": "\$12.27",
            "discountAtm": "",
            "amount": "\$12.27",
            "imgUrl": ""
          },
          {
            "id": 627,
            "itemNo": "BEV-00081",
            "group": "", // Different group for the item
            "description": "Luna Iced Latte - Large",
            "description2": "",
            "quantity": 6.00,
            "unitPrice": "\$4.09",
            "subTotal": "\$24.54",
            "discountAtm": "",
            "amount": "\$24.54",
            "imgUrl": ""
          }
        ]
      },
      {
        "group": "group1", // Group for the record
        "totalAmount": "",
        "items": [
          {
            "id": 626,
            "itemNo": "BEV-00019",
            "group": "group1", // Group for the item
            "description": "Hot Cappuccino - Medium",
            "description2": "",
            "quantity": 3.00,
            "unitPrice": "\$4.09",
            "subTotal": "\$12.27",
            "discountAtm": "",
            "amount": "\$12.27",
            "imgUrl": ""
          },
          {
            "id": 627,
            "itemNo": "BEV-00081",
            "group": "group1", // Different group for the item
            "description": "Luna Iced Latte - Large",
            "description2": "",
            "quantity": 3.00,
            "unitPrice": "\$4.09",
            "subTotal": "\$24.54",
            "discountAtm": "",
            "amount": "\$24.54",
            "imgUrl": ""
          }
        ]
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const Drawer(
        child: DrawerPath(),
      ),
      appBar: AppBar(
        centerTitle: false,
        leading: InkWell(
          onTap: () => _key.currentState!.openDrawer(),
          child: const Icon(
            Icons.filter_list_outlined,
            color: greenColor,
          ),
        ),
        title: Image.asset("assets/images/tomnenh.png"),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: CirCleBtn(
              width: 36,
              height: 40,
              isRedNote: true,
              iconSvg: bellSvg,
              paddingIconSvg: 8,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              containerCus(icon: customerSvg, title: "Dashboard", value: "30"),
              containerCus(icon: itemsSvg, title: "Items", value: "190"),
            ],
          ),
          Flexible(
              flex: 3,
              child: SfCartesianChart(
                  backgroundColor: Colors.transparent,
                  primaryXAxis: const CategoryAxis(
                      isVisible: true,
                      labelStyle: TextStyle(overflow: TextOverflow.ellipsis),
                      majorGridLines: MajorGridLines(width: 0)),
                  series: <CartesianSeries<dynamic, dynamic>>[
                    // Renders spline chart
                    SplineSeries<ChartData, String>(
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      enableTooltip: true,
                      dataSource: chartData,
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) =>
                          data.x, // Map the day as a string
                      yValueMapper: (ChartData data, _) =>
                          data.y, // Map the value as a double
                    ),
                  ])),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                subContainerCus(
                  icon: listSvg,
                  containerColor: greenColor,
                  title: "View all List items",
                  subTitle:
                      "Display each Items with its name \n description and attribute",
                ),
                subContainerCus(
                  icon: phoneSvg,
                  containerColor: green50Color,
                  title: "Contact Customer",
                  subTitle:
                      "Provide each contact's name, phone number, \nemail address, and other relevant details.",
                ),
              ],
            ),
          ),
        ],
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

  Widget containerCus({String? title, String? value, String? icon}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [green50Color, greenColor])),
        child: Row(
          children: [
            SvgPicture.asset(icon ?? ""),
            const SizedBox(width: 16),
            Column(
              children: [
                Text(
                  title ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
