import 'package:flutter/material.dart';

import './widgets.dart';
import '../utils/utils.dart';

class CustomAppBar extends StatelessWidget {
  final String leadingIcon;
  final String title;
  final String? trailingIcon;

  final VoidCallback onLeadingIconPressed;
  final VoidCallback? onTrailingIconPressed;

  const CustomAppBar({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onLeadingIconPressed,
    this.trailingIcon,
    this.onTrailingIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // leading
          InkWell(
            onTap: onLeadingIconPressed,
            child: DynamicIcon(leadingIcon),
          ),
          // title
          Expanded(
            flex: 1,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // trailing
          if (trailingIcon != null)
            InkWell(
              onTap: onTrailingIconPressed,
              child: DynamicIcon(
                trailingIcon,
                size: 22,
              ),
            ),
        ],
      ),
    );
  }
}
