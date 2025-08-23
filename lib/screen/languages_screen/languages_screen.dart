import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/languages_screen/languages_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class LanguagesScreen extends StatelessWidget {
  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LanguagesScreenController());
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (c) {
          return Column(
            children: [
              TopBarArea(title: S.of(context).language),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Theme(
                        data: ThemeData(unselectedWidgetColor: ColorRes.royalBlue),
                        child: RadioListTile(
                          value: index,
                          groupValue: controller.value,
                          dense: true,
                          activeColor: ColorRes.royalBlue,
                          onChanged: controller.onLanguageChange,
                          title: Text(
                            controller.languages[index],
                            style: MyTextStyle.productMedium(),
                          ),
                          subtitle: Text(
                            controller.subLanguage[index],
                            style: MyTextStyle.productLight(),
                          ),
                        ),
                      );
                    },
                    itemCount: controller.languages.length,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
