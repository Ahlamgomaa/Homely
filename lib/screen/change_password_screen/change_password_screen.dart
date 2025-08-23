import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/suggestion_text.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_textfield.dart';
import 'package:homely/screen/change_password_screen/change_password_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordScreenController());
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: S.of(context).changePassword),
          GetBuilder(
            init: controller,
            builder: (controller) => Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: 2,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return index == 0
                      ? SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  S.of(context).toSetANewPasswordPleaseEnterYourCurrentPassword,
                                  style: MyTextStyle.productRegular(size: 18, color: ColorRes.silverChalice),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SuggestionText(title: S.of(context).currentPassword),
                                AddEditPropertyTextField(
                                  controller: controller.currentPasswordController,
                                  obscureText: true,
                                  marginVertical: 10,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: InkWell(
                                    onTap: controller.onForgotPasswordClick,
                                    child: SuggestionText(
                                      title: S.of(context).forgotYourPassword,
                                      fontSize: 13,
                                      color: ColorRes.royalBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  S.of(context).setAGoodPasswordByUsingACombinationOfLowercase,
                                  style: MyTextStyle.productRegular(size: 18, color: ColorRes.silverChalice),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SuggestionText(title: S.of(context).newPassword),
                                AddEditPropertyTextField(
                                  controller: controller.newPasswordController,
                                  obscureText: true,
                                  marginVertical: 10,
                                ),
                                SuggestionText(title: S.of(context).confirmPassword),
                                AddEditPropertyTextField(
                                  controller: controller.confirmPasswordController,
                                  obscureText: true,
                                  marginVertical: 10,
                                ),
                              ],
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: TextButtonCustom(
                onTap: controller.onSubmitClick,
                title: S.of(context).submit,
              ),
            ),
          )
        ],
      ),
    );
  }
}
