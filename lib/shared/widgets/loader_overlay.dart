import 'package:flutter/material.dart';

import '../utils/utils.dart';

class LoaderOverlay extends StatelessWidget {
  final Widget child;
  final bool showLoader;

  const LoaderOverlay({
    super.key,
    required this.showLoader,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showLoader) ...[
          const Opacity(
            opacity: 0.4,
            child:
                ModalBarrier(dismissible: false, color: AppColors.blackColor),
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ],
    );
  }
}
