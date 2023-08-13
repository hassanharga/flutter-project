import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DynamicIcon extends StatelessWidget {
  final dynamic icon;
  final double size;
  final Color? color;
  final BoxFit fit;
  const DynamicIcon(
    this.icon, {
    super.key,
    this.size = 20,
    this.color,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    Widget defaultIcon = const SizedBox(
      width: 0,
      height: 0,
    );

    if (icon is IconData) {
      IconData iconData = icon as IconData;
      defaultIcon = Icon(
        iconData,
        color: color,
        size: size + 2,
      );
    } else if (icon is String) {
      String strIcon = (icon as String);
      if (strIcon.endsWith("svg")) {
        defaultIcon = SvgPicture.asset(
          strIcon,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(
                  color!,
                  BlendMode.srcIn,
                )
              : null,
          height: size + 2,
        );
      } else if (strIcon.startsWith("http") || strIcon.startsWith("ftp")) {
        defaultIcon = Image.network(
          strIcon,
          fit: fit,
          height: size + 2,
        );
      } else {
        defaultIcon = Image.asset(
          strIcon,
          fit: fit,
          height: size + 2,
        );
      }
    }

    return defaultIcon;
  }
}
