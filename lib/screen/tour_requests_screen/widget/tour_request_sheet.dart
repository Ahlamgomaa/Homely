import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/tour/fetch_property_tour.dart';
import 'package:homely/screen/tour_requests_screen/tour_requests_screen_controller.dart';
import 'package:homely/screen/tour_requests_screen/widget/tour_request_card.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class TourRequestSheet extends StatelessWidget {
  final TourRequestsScreenController controller;
  final FetchPropertyTourData data;

  const TourRequestSheet({
    super.key,
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
      child: Wrap(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: ColorRes.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).propertyTourRequest,
                          style: MyTextStyle.productBlack(size: 20, color: ColorRes.daveGrey),
                        ),
                        Text(
                          S.of(context).acceptOrDeclineTheRequestToLetTheBuyerKnow,
                          style: MyTextStyle.productLight(size: 16, color: ColorRes.daveGrey),
                        ),
                      ],
                    ),
                  ),
                  TourRequestCard(data: data),
                  const SizedBox(
                    height: 25,
                  ),
                  data.tourStatus == 0
                      ? Column(
                          children: [
                            TourButton(
                                onTap: () {
                                  controller.onWaitingSheetButtonClick(data, 0);
                                },
                                title: S.current.accept,
                                color: ColorRes.irishGreen),
                            const SizedBox(
                              height: 10,
                            ),
                            TourButton(
                                onTap: () {
                                  controller.onWaitingSheetButtonClick(data, 1);
                                },
                                title: S.current.decline,
                                color: ColorRes.sunsetOrange),
                          ],
                        )
                      : Column(
                          children: [
                            InkWell(
                              onTap: () {
                                controller.onWaitingSheetButtonClick(data, 2);
                              },
                              child: Container(
                                height: 55,
                                width: double.infinity,
                                color: ColorRes.royalBlue.withValues(alpha: 0.12),
                                alignment: Alignment.center,
                                child: Text(
                                  S.of(context).markCompleted,
                                  style: MyTextStyle.productRegular(
                                      size: 17, color: ColorRes.royalBlue),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: 55,
                            )
                          ],
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TourButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color color;

  const TourButton({super.key, required this.onTap, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        width: double.infinity,
        color: color.withValues(alpha: 0.12),
        alignment: Alignment.center,
        child: Text(
          title,
          style: MyTextStyle.productRegular(size: 17, color: color),
        ),
      ),
    );
  }
}
