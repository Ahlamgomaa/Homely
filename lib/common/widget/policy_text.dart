import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/webview_screen/webview_screen.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';
import 'package:homely/utils/url_res.dart';

class PolicyText extends StatelessWidget {
  const PolicyText({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: S.of(context).byProceedingForwardYouAgreeToThe,
            style: MyTextStyle.productRegular(color: ColorRes.silverChalice, size: 15),
            children: <TextSpan>[
              TextSpan(
                text: '\n${S.of(context).privacyPolicy} ',
                style: MyTextStyle.productRegular(color: ColorRes.balticSea, size: 15),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    NavigateService.push(
                        context,
                        WebviewScreen(
                          title: S.of(context).privacyPolicy,
                          url: UrlRes.privacyPolicy,
                        ));
                  },
              ),
              TextSpan(
                text: '${S.of(context).and} ',
                style: MyTextStyle.productRegular(color: ColorRes.silverChalice, size: 15),
              ),
              TextSpan(
                text: S.of(context).termsConditions,
                style: MyTextStyle.productRegular(
                  color: ColorRes.balticSea,
                  size: 15,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    NavigateService.push(
                      context,
                      WebviewScreen(
                        title: S.of(context).termsOfUse,
                        url: UrlRes.termsOfUse,
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
