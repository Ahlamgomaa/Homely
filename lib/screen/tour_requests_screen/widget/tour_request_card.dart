import 'package:flutter/material.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/model/tour/fetch_property_tour.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class TourRequestCard extends StatelessWidget {
  final FetchPropertyTourData data;

  const TourRequestCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 3),
      color: ColorRes.whiteSmoke.withValues(alpha: 0.5),
      child: Row(
        children: [
          CommonFun.getMedia(m: data.property?.media ?? [], mediaId: 1).isEmpty
              ? CommonUI.errorPlaceholder(width: 95, height: 95)
              : Image.network(
                  CommonFun.getMedia(m: data.property?.media ?? [], mediaId: 1),
                  width: 95,
                  height: 95,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return CommonUI.errorPlaceholder(width: 95, height: 95);
                  },
                ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.property?.title ?? '',
                  style: MyTextStyle.productBold(size: 17),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  data.property?.address ?? '',
                  style: MyTextStyle.productLight(size: 15, color: ColorRes.conCord),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  CommonFun.dateFormat(data.timeZone ?? ''),
                  style: MyTextStyle.productRegular(color: ColorRes.conCord, size: 15),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
