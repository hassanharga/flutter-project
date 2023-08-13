import 'package:flutter/material.dart';
import 'package:rateel/shared/constants/assets_manager.dart';
import 'package:rateel/shared/utils/utils.dart';

import '../../../shared/widgets/widgets.dart';

class RateelTools extends StatelessWidget {
  const RateelTools({super.key});

  List<Map<String, dynamic>> _tools(BuildContext context) {
    return [
      {
        'label': translate(context).planWird,
        "icon": ImgAssets.wird,
        'color': AppColors.grayColor3,
      },
      {
        'label': translate(context).reciterVoice,
        "icon": ImgAssets.mic,
        'color': AppColors.orangeColor,
      },
      {
        'label': translate(context).sebha,
        "icon": ImgAssets.sebha,
        'color': AppColors.cyanColor,
      },
      {
        'label': translate(context).favouriteDuaa,
        "icon": ImgAssets.wird,
        'color': AppColors.purpleColor,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO add actions for each element
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: translate(context).tools,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _tools(context)
                  .map(
                    (e) => Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 100,
                      height: 100,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: e['color'],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DynamicIcon(
                            e['icon'],
                            color: AppColors.whiteColor,
                          ),
                          Text(
                            e['label'],
                            style: const TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
