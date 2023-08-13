import 'package:flutter/material.dart';

import '../../../shared/constants/constants.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

class SectionTitle extends StatelessWidget {
  // NOTE all icon should be svg from design
  final String title;
  final String? leadingIcon;
  final String? trailingText;
  final String? trailingIcon;
  final Color? trailingTextColor;
  final Function()? onTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.leadingIcon,
    this.trailingText,
    this.trailingIcon,
    this.trailingTextColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      leading: leadingIcon != null ? DynamicIcon(leadingIcon!) : null,
      title: Text(title),
      trailing: (trailingText != null || trailingIcon != null)
          ? InkWell(
              onTap: onTap,
              child: trailingText != null
                  ? Text(trailingText ?? '')
                  : DynamicIcon(
                      trailingIcon,
                      color: trailingTextColor ?? AppColors.primaryColor,
                    ),
            )
          : null,
      leadingAndTrailingTextStyle: TextStyle(
        color: trailingTextColor ?? AppColors.primaryColor,
        fontFamily: FONT_FAMILY,
        fontSize: 12,
      ),
    );
  }
}
