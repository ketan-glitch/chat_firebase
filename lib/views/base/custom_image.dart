import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../generated/assets.dart';

export '../../generated/assets.dart';

class CustomAssetImage extends StatelessWidget {
  const CustomAssetImage({Key? key, required this.path, this.height, this.width, this.color, this.fit, this.alignment}) : super(key: key);

  final String path;
  final Color? color;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(path),
      fit: fit,
      height: height,
      width: width,
      color: color,
      alignment: alignment ?? Alignment.center,
    );
  }
}

class CustomImage extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? placeholder;
  final String? onError;
  final Color? color;
  const CustomImage({
    Key? key,
    required this.path,
    this.height,
    this.width,
    this.fit,
    this.placeholder,
    this.color,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log('${image.replaceAll('\\', '/')}',name: "IMAGE");
    String p = path.replaceAll('\\', '/');
    // log(p,name: "IMAGE");
    return CachedNetworkImage(
      imageUrl: p,
      height: height,
      width: width,
      fit: fit,
      placeholderFadeInDuration: const Duration(seconds: 1),
      placeholder: (context, imageUrl) {
        return Center(
          child: Transform(
            transform: placeholder != null ? Matrix4.diagonal3Values(0.75, 0.75, 1) : Matrix4.diagonal3Values(1, 1, 1),
            alignment: Alignment.center,
            child: Image.asset(
              placeholder != null ? placeholder! : Assets.imagesShimmer,
              height: height,
              width: width,
              fit: fit,
            ),
          ),
        );
      },
      errorWidget: (context, imageUrl, stackTrace) {
        log('$stackTrace', name: "stackTrace");
        return Image.asset(
          onError != null ? onError! : Assets.imagesPlaceholder,
          height: height,
          width: width,
          fit: fit,
          color: color,
        );
      },
    );
  }
}
