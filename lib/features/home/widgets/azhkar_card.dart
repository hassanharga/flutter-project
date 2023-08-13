import 'package:flutter/material.dart';

import '../../../shared/utils/utils.dart';

class AzkarCard extends StatelessWidget {
  final bool showMorning;
  final bool showEvening;

  const AzkarCard({
    super.key,
    required this.showMorning,
    required this.showEvening,
  });

  Card _azkarCardDetails(String name) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      elevation: 2,
      color: AppColors.whiteColor,
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 45,
        child: Row(
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.grayColor4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (showMorning || showEvening)
        ? Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate(context).homeAzkarMsg1,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  translate(context).homeAzkarMsg2,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.grayColor4,
                  ),
                ),
                const SizedBox(height: 5),
                if (showMorning)
                  _azkarCardDetails(translate(context).morningAzkar),
                if (showEvening)
                  _azkarCardDetails(translate(context).eveningAzkar),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
