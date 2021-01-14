import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import '../common_utils/mpsf_image_utils.dart';

/// 图片加载（支持本地与网络图片）
class MpsfImageView extends StatelessWidget {
  const MpsfImageView(this.image,
      {Key key,
      this.width,
      this.height,
      this.fit: BoxFit.cover,
      this.format,
      this.holderImg})
      : super(key: key);

  final String image;
  final double width;
  final double height;
  final BoxFit fit;
  final String format;
  final String holderImg;

  @override
  Widget build(BuildContext context) {
    Widget placeHolder = MpsfLoadAssetImage(
      holderImg,
      height: height,
      width: width,
      fit: fit,
      format: format,
    );

    if (TextUtil.isEmpty(image) || image == "null") {
      return placeHolder;
    } else {
      if (image.startsWith("http")) {
        return CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) {
            return placeHolder;
          },
          errorWidget: (context, url, error) {
            return placeHolder;
          },
          width: width,
          height: height,
          fit: fit,
        );
      } else {
        return placeHolder;
      }
    }
  }
}

/// 加载本地资源图片
class MpsfLoadAssetImage extends StatelessWidget {
  const MpsfLoadAssetImage(this.image,
      {Key key, this.width, this.height, this.fit, this.format, this.color})
      : super(key: key);

  final String image;
  final double width;
  final double height;
  final BoxFit fit;
  final String format;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      MpsfImageUtils.getImgPath(image, format: format),
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }
}
