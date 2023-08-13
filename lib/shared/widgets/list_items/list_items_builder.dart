import 'package:flutter/material.dart';
import 'package:rateel/shared/utils/screen_sizes.dart';
import 'package:rateel/shared/widgets/widgets.dart';

export 'list_item.dart';

// List items types:
// 1- Image with title and sub title and Trailing image.
// 2- Image with title and sub title and two Trailing iamges.
// 3- Image with title and Trailing image.
// 4- Image with title and sub title. Done ✅
// 5- Image with title. Done ✅
// 6- Image with title and Trailing text and image.
// 7- Title only. Done ✅
// 8- Title and Trailing image.
// 9- Title with switch.

class ListItemsBuilder extends StatelessWidget {
  final ListItem listItem;
  final GestureTapCallback? onTap;
  const ListItemsBuilder({super.key, required this.listItem, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: 70,
        width: ScreenSize.width,
        alignment: Alignment.center,
        child: ListTile(
          onTap: onTap,
          leading: listItem.buildLeadingImage(context),
          title: listItem.buildTitle(context),
          subtitle: listItem.buildSubtitle(context),
          trailing: listItem.buildTrailing(context),
        ));
  }
}
