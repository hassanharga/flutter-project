import 'package:flutter/material.dart';
import 'widgets.dart';

class BottomSheetModel {
  String title;
  String? id;
  DynamicIcon? trailingIcon;

  BottomSheetModel({required this.title, this.id, required this.trailingIcon});
}

Future<dynamic> modelBottomSheet(
    {required BuildContext context,
    String? sectionTitle,
    required Function callbackFunction,
    required List<BottomSheetModel> bottomSheetModel}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: SafeArea(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                _modelBottomSheetNotch(context),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (sectionTitle != null)
                        SectionTitle(title: sectionTitle),
                      for (var item in bottomSheetModel) ...[
                        const Divider(height: 0),
                        ListItemsBuilder(
                          listItem: ListItem(
                              title: item.title,
                              trailingIcon: item.trailingIcon),
                          onTap: () {
                            Navigator.pop(context);
                            callbackFunction(item.id);
                          },
                        ),
                      ]
                    ])
              ],
            ),
          ),
        );
      });
}

Widget _modelBottomSheetNotch(BuildContext context) {
  return FractionallySizedBox(
    widthFactor: 0.15,
    child: Container(
      margin: const EdgeInsets.symmetric(
        vertical: 12.0,
      ),
      child: Container(
        height: 5.0,
        decoration: const BoxDecoration(
          color: Color.fromARGB(30, 0, 0, 0),
          borderRadius: BorderRadius.all(Radius.circular(2.5)),
        ),
      ),
    ),
  );
}
