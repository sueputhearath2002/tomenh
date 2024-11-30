//
//
// import 'package:flutter/material.dart';
//
// class DashboardScreenV1 extends StatelessWidget {
//   const DashboardScreenV1({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         leading: InkWell(
//           onTap: () => _key.currentState!.openDrawer(),
//           child: const Icon(
//             Icons.filter_list_outlined,
//             color: greenColor,
//           ),
//         ),
//         title: Image.asset("assets/images/tomnenh.png"),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             child: CirCleBtn(
//               width: 36,
//               height: 40,
//               isRedNote: true,
//               iconSvg: bellSvg,
//               paddingIconSvg: 8,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
