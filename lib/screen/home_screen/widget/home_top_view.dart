import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/notification_screen/notification_screen.dart';
import 'package:homely/screen/search_screen/search_screen.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class HomeTopView extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onResetCityBtn;
  final String address;
  final bool isResetBtnVisible;

  const HomeTopView(
      {super.key,
      required this.onTap,
      required this.address,
      required this.onResetCityBtn,
      required this.isResetBtnVisible});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.whiteSmoke,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        S.of(context).selectCity,
                        style: MyTextStyle.productLight(
                          color: ColorRes.doveGrey,
                          size: 16,
                        ),
                      ),
                      Visibility(
                        visible: isResetBtnVisible,
                        child: InkWell(
                          onTap: onResetCityBtn,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                            decoration:
                                BoxDecoration(color: ColorRes.greenWhite, borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              S.of(context).reset,
                              style: MyTextStyle.productMedium(size: 16, color: ColorRes.doveGrey),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: onTap,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            '$address ',
                            style: MyTextStyle.productBold(
                              size: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: ColorRes.royalBlue,
                          size: 35,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            TopIcon(
              icon: Icons.search,
              onTap: () {
                NavigateService.push(context, const SearchScreen());
              },
            ),
            const SizedBox(
              width: 7,
            ),
            TopIcon(
              icon: Icons.notifications,
              onTap: () {
                NavigateService.push(Get.context!, const NotificationScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TopIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const TopIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ColorRes.royalBlue, width: 1.5),
        ),
        child: Icon(
          icon,
          size: 23,
          color: ColorRes.royalBlue,
        ),
      ),
    );
  }
}
