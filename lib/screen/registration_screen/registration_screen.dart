import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/policy_text.dart';
import 'package:homely/common/widget/suggestion_text.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_textfield.dart';
import 'package:homely/screen/registration_screen/registration_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = RegistrationScreenController();
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              TopBarArea(title: S.of(context).registration),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          S.of(context).pleaseFillYourDetailsAndCompleteRegistrationToStartExploreRent,
                          style: MyTextStyle.productRegular(size: 18, color: ColorRes.silverChalice),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SuggestionText(title: S.of(context).fullname),
                        AddEditPropertyTextField(
                          controller: controller.fullnameController,
                          textInputType: TextInputType.name,
                          marginVertical: 10,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SuggestionText(title: S.of(context).email),
                        AddEditPropertyTextField(
                          controller: controller.emailController,
                          textInputType: TextInputType.emailAddress,
                          marginVertical: 10,
                        ),
                        SuggestionText(title: S.of(context).password),
                        AddEditPropertyTextField(
                          controller: controller.passwordController,
                          textInputType: TextInputType.visiblePassword,
                          marginVertical: 10,
                          obscureText: true,
                        ),
                        SuggestionText(title: S.of(context).retypePassword),
                        AddEditPropertyTextField(
                          controller: controller.reTypeController,
                          textInputType: TextInputType.visiblePassword,
                          marginVertical: 10,
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButtonCustom(onTap: controller.onSubmitClick, title: S.current.submit),
                        const SizedBox(
                          height: 25,
                        ),
                        const PolicyText(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
