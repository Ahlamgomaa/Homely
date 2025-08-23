import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/what_are_you_here_screen/what_are_you_here_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class WhatAreYouHereScreen extends StatelessWidget {
  final UserData? userData;

  const WhatAreYouHereScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WhatAreYouHereScreenController(userData));
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: S.of(context).whatAreYouHereFor),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Text(
                  S.of(context).pleaseSelectAnyOfTheAppropriateOptionFromBelowThat,
                  style: MyTextStyle.productRegular(size: 18, color: ColorRes.silverChalice),
                ),
                const SizedBox(
                  height: 25,
                ),
                GetBuilder(
                  id: controller.selectTypeID,
                  init: controller,
                  builder: (controller) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.whatAreYouHereList.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => controller.onSelectedType(index),
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: ColorRes.whiteSmoke,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: controller.selectedType == index ? ColorRes.royalBlue : ColorRes.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              controller.whatAreYouHereList[index],
                              style: MyTextStyle.productRegular(
                                size: 18,
                                color: controller.selectedType == index ? ColorRes.royalBlue : ColorRes.gunSmoke,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
          const Spacer(),
          TextButtonCustom(
            onTap: controller.onSubmitClick,
            title: S.of(context).submit,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
