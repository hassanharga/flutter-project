import 'package:flutter/material.dart';
import 'package:rateel/shared/widgets/widgets.dart';
import 'package:rateel/shared/utils/utils.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String appLanguage = 'ar';

  void updatedValue(data) async {
    setState(() {
      appLanguage = data;
    });
  }

  String languageString() {
    if (appLanguage == 'ar') {
      return 'العربية';
    } else {
      return 'English';
    }
  }

  void openLanguageBottomSheet() {
    modelBottomSheet(
        context: context,
        sectionTitle: 'إختر لغة التطبيق',
        callbackFunction: updatedValue,
        bottomSheetModel: [
          BottomSheetModel(
              title: "العربية",
              id: "ar",
              trailingIcon:
                  appLanguage == 'ar' ? const DynamicIcon(Icons.check) : null),
          BottomSheetModel(
              title: "English",
              id: "en",
              trailingIcon:
                  appLanguage == 'en' ? const DynamicIcon(Icons.check) : null)
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'المزيد',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primaryColor,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'الإعدادات'),
            ListItemsBuilder(
              listItem: TitleWithDetailsAndImage(
                  title: 'إختر لغة التطبيق',
                  leadingIcon: const DynamicIcon(Icons.language),
                  trailingIcon: const DynamicIcon(Icons.arrow_back_ios_new),
                  trailingDetails: languageString()),
              onTap: openLanguageBottomSheet,
            ),
            const Divider(height: 0),
            ListItemsBuilder(
                listItem: ListItem(
                    title: 'التنبيهات',
                    leadingIcon: const DynamicIcon(Icons.notifications))),
            const Divider(height: 0),
            ListItemsBuilder(
                listItem: ListItem(
                    title: 'شارك التطبيق',
                    leadingIcon: const DynamicIcon(Icons.ios_share))),
            const Divider(height: 0),
            ListItemsBuilder(
                listItem: ListItem(
                    title: 'رقم الإصدار',
                    leadingIcon: const DynamicIcon(Icons.info))),
          ],
        ));
  }
}
