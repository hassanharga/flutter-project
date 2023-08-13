import 'package:flutter/material.dart';
import 'package:rateel/shared/widgets/widgets.dart';
export './title_details_image_list_item.dart';

/// A ListItem that display title.
class ListItem {
  String? id;
  final String title;
  DynamicIcon? leadingIcon;
  String? subtitle;
  DynamicIcon? trailingIcon;

  ListItem(
      {this.id,
      required this.title,
      this.leadingIcon,
      this.subtitle,
      this.trailingIcon});

  Widget? buildLeadingImage(BuildContext context) {
    if (leadingIcon != null) {
      return leadingIcon;
    } else {
      return null;
    }
  }

  Widget buildTitle(BuildContext context) {
    return Text(title);
  }

  Widget? buildSubtitle(BuildContext context) {
    if (subtitle != null) {
      return Text(subtitle!);
    } else {
      return null;
    }
  }

  Widget? buildTrailing(BuildContext context) {
    if (trailingIcon != null) {
      return trailingIcon;
    } else {
      return null;
    }
  }
}
