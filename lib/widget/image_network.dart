import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tomnenh/style/assets.dart';

class ImageNetWorkWidget extends StatelessWidget {
  const ImageNetWorkWidget({
    super.key,
    required this.width,
    required this.height,
    required this.imageUrl,
    this.topRight = 16,
    this.topLeft = 16,
    this.bottomLeft = 16,
    this.bottomRight = 16,
    this.border,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double width;
  final double height;
  final double topRight;
  final double topLeft;
  final double bottomLeft;
  final double bottomRight;
  final BoxBorder? border;
  final BoxFit fit;

  String get getImgUrl =>
      Platform.isAndroid ? imageUrl.replaceAll("https", "http") : imageUrl;

  @override
  Widget build(BuildContext context) {
    if (getImgUrl == "") {
      return Container(
        key: key,
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(noImage),
            fit: BoxFit.cover,
          ),
          borderRadius: buildBorderRadius(),
        ),
      );
    }

    return CachedNetworkImage(
      key: key,
      imageUrl: getImgUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          key: key,
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
            borderRadius: buildBorderRadius(),
            border: border,
          ),
        );
      },
      placeholder: (context, url) {
        // return Container(
        //   alignment: Alignment.center,
        //   width: width,
        //   height: height,
        //   child: const SizedBox(
        //     width: 30,
        //     height: 30,
        //     child: CircularProgressIndicator(
        //       strokeWidth: 2,
        //       color: gPrimary,
        //     ),
        //   ),
        // );
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(noImage),
              fit: BoxFit.cover,
            ),
            borderRadius: buildBorderRadius(),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(noImage),
              fit: BoxFit.cover,
            ),
            borderRadius: buildBorderRadius(),
          ),
        );
      },
    );
  }

  BorderRadius buildBorderRadius() {
    return BorderRadius.only(
      topRight: Radius.circular(topRight),
      topLeft: Radius.circular(topLeft),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }
}
