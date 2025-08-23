import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/auth_top_card.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/auth_screen/auth_screen_controller.dart';
import 'package:homely/screen/login_screen/login_screen.dart';
import 'package:homely/screen/registration_screen/registration_screen.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthScreenController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder(
        init: controller,
        builder: (controller) => Column(
          children: [
            const AuthTopCard(),
            const Spacer(flex: 2),
            Text(
              S.of(context).discoverBuyRentndreamHomeFromSmartPhone,
              style: MyTextStyle.productBold(size: 22),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Text(
              S.of(context).no1AppToFindAndSearchMostnperfectSuitableHome,
              style: MyTextStyle.productRegular(size: 16, color: ColorRes.silverChalice),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            TextButtonCustom(
              onTap: () {
                NavigateService.push(context, const RegistrationScreen());
              },
              title: S.of(context).register,
            ),
            const Spacer(),
            RichText(
              text: TextSpan(
                text: S.of(context).alreadyHaveAnAccount,
                style: MyTextStyle.productRegular(color: ColorRes.silverChalice, size: 18),
                children: <TextSpan>[
                  TextSpan(
                    text: ' ${S.of(context).logIn}',
                    style: MyTextStyle.productBold(color: ColorRes.balticSea, size: 18),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        NavigateService.push(context, const LoginScreen());
                      },
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
