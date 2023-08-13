import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'widgets.dart';

enum ButtonType { primary, secondary }

enum ButtonWidth { auto, full }

class ButtonWidget extends StatelessWidget {
  final String label;
  final DynamicIcon? icon;
  final ButtonType? type;
  final ButtonWidth? width;
  final VoidCallback? onPressed;
  final double? fontSize;
  final FontWeight? fontWeight;

  const ButtonWidget(
      {super.key,
      required this.label,
      this.icon,
      this.type = ButtonType.primary,
      this.width = ButtonWidth.full,
      this.fontSize = 20,
      this.fontWeight = FontWeight.normal,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    Color btnbackgroundColor = AppColors.primaryColor;
    Color btnforegroundColor = AppColors.whiteColor;
    double borderSize = 0;
    double btnMargin = 0;

    switch (type) {
      case ButtonType.secondary:
        btnbackgroundColor = AppColors.whiteColor;
        btnforegroundColor = AppColors.primaryColor;
        borderSize = 1;
        btnMargin = 10;
        break;
      case ButtonType.primary:
      default:
        btnbackgroundColor = AppColors.primaryColor;
        btnforegroundColor = AppColors.whiteColor;
    }

    return Container(
      margin: EdgeInsets.all(btnMargin),
      alignment: Alignment.center,
      color: AppColors.cyanColor,
      child: Column(
        children: [
          // const SizedBox(
          //   height: 60,
          // ),
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon ?? DynamicIcon(icon),
            label: Text(
              label,
              style: TextStyle(
                fontWeight: fontWeight,
                fontSize: fontSize,
              ),
            ),
            style: ButtonStyle(
              minimumSize: width == ButtonWidth.full
                  ? MaterialStateProperty.all(const Size.fromHeight(60))
                  : null,
              padding: const MaterialStatePropertyAll(
                  EdgeInsets.fromLTRB(30, 12, 30, 12)),
              backgroundColor: MaterialStateProperty.all(btnbackgroundColor),
              foregroundColor: MaterialStateProperty.all(btnforegroundColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: width == ButtonWidth.auto
                      ? BorderRadius.circular(5)
                      : BorderRadius.zero,
                  side: BorderSide(
                    color: AppColors.grayColor,
                    width: borderSize,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
