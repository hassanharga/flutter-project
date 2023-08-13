import 'package:flutter/material.dart';
import '../widgets.dart';

class TitleWithDetailsAndImage extends ListItem {
  final String trailingDetails;
  TitleWithDetailsAndImage(
      {required super.title,
      super.leadingIcon,
      super.trailingIcon,
      required this.trailingDetails});

  @override
  Widget buildTrailing(BuildContext context) {
    return Wrap(children: [
      Text(
        trailingDetails,
        style:
            const TextStyle(fontSize: 15, color: Color.fromARGB(95, 0, 0, 0)),
      ),
      const SizedBox(width: 5),
      if (trailingIcon != null) trailingIcon!
    ]);
  }
}
