import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/policy_text.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/setting.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_textfield.dart';
import 'package:homely/screen/support_screen/support_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SupportScreenController();
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (controller) => Column(
          children: [
            TopBarArea(title: S.of(context).support),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).pleaseExplainAboutYourIssueBrieflyWeWillSureLook,
                        style: MyTextStyle.productRegular(
                          size: 18,
                          color: ColorRes.silverChalice,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          S.of(context).subject,
                          style: MyTextStyle.productRegular(
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(color: ColorRes.snowDrift, borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton<SupportSubject>(
                          value: controller.selectedSubject,
                          icon: const Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 40,
                          ),
                          menuMaxHeight: 200,
                          isExpanded: true,
                          iconEnabledColor: ColorRes.royalBlue,
                          style: MyTextStyle.productRegular(size: 17, color: ColorRes.mediumGrey),
                          underline: const SizedBox(),
                          borderRadius: BorderRadius.circular(10),
                          hint: Text(
                            S.of(context).selectSupport,
                            style: MyTextStyle.productRegular(size: 16, color: ColorRes.mediumGrey),
                          ),
                          onChanged: controller.onSupportChange,
                          items: controller.supports.map<DropdownMenuItem<SupportSubject>>((SupportSubject value) {
                            return DropdownMenuItem<SupportSubject>(
                              value: value,
                              child: Text(
                                value.title ?? '',
                                style: MyTextStyle.productRegular(
                                  size: 17,
                                  color: ColorRes.mediumGrey,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          S.of(context).description,
                          style: MyTextStyle.productRegular(
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AddEditPropertyTextField(
                        controller: controller.descriptionController,
                        isExpand: true,
                        textInputType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButtonCustom(onTap: controller.onSubmitClick, title: S.of(context).submit),
                      const SizedBox(
                        height: 35,
                      ),
                      const PolicyText(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
