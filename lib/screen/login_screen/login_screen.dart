import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/auth_top_card.dart';
import 'package:homely/common/widget/policy_text.dart';
import 'package:homely/common/widget/suggestion_text.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_textfield.dart';
import 'package:homely/screen/login_screen/login_screen_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LoginScreenController();
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                const AuthTopCard(isBackBtnVisible: true),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: controller.onForgotPasswordClick,
                          child: SuggestionText(title: S.of(context).forgetPassword),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButtonCustom(
                        onTap: controller.onSubmitClick,
                        title: S.of(context).submit,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const PolicyText(),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
