import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/blur_bg_icon.dart';
import 'package:homely/common/widget/suggestion_text.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_textfield.dart';
import 'package:homely/screen/login_screen/login_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class ForgotPasswordSheet extends StatelessWidget {
  const ForgotPasswordSheet({super.key});

  @override
  Widget build(BuildContext context) {
    LoginScreenController controller = Get.find();
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).forgotPassword,
                    style: MyTextStyle.productRegular(size: 24),
                  ),
                  BlurBGIcon(
                      icon: Icons.close,
                      onTap: () {
                        Get.back();
                      },
                      color: ColorRes.black.withValues(alpha: 0.6),
                      iconColor: ColorRes.white)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SuggestionText(title: S.current.email),
              AddEditPropertyTextField(
                controller: controller.forgotMailController,
                textInputType: TextInputType.emailAddress,
                marginVertical: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButtonCustom(onTap: controller.onForgotBtnClick, title: S.of(context).send),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
