import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tomnenh/style/colors.dart';

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  const DashedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Ensure padding for visibility
        child: child,
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = mainColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5.0;
    const double dashSpace = 5.0;
    const double borderRadius = 8;

    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rRect);
    final PathMetrics pathMetrics = path.computeMetrics();

    for (final PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final Path extractPath = pathMetric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
