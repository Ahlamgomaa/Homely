import 'package:flutter/material.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_textfield.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SendPropertySheet extends StatelessWidget {
  final PropertyData data;
  final Function(PropertyData, String) onSendBtnClick;

  const SendPropertySheet({super.key, required this.data, required this.onSendBtnClick});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).sendProperty,
                        style: MyTextStyle.productBlack(size: 20, color: ColorRes.daveGrey),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  color: ColorRes.whiteSmoke.withValues(alpha: 0.5),
                  child: Row(
                    children: [
                      CommonFun.getMedia(m: data.media ?? [], mediaId: 1).isEmpty
                          ? CommonUI.errorPlaceholder(width: 95, height: 95)
                          : Image.network(
                              CommonFun.getMedia(m: data.media ?? [], mediaId: 1),
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
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              data.title ?? '',
                              style: MyTextStyle.productBold(size: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              (data.propertyType?.title ?? '').toUpperCase(),
                              style: MyTextStyle.productMedium(size: 12, color: ColorRes.royalBlue),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              data.address ?? '',
                              style: MyTextStyle.productLight(size: 15, color: ColorRes.conCord),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).description,
                        style: MyTextStyle.productRegular(
                          size: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AddEditPropertyTextField(
                        controller: controller,
                        isExpand: true,
                        textInputType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      TextButtonCustom(
                          onTap: () => onSendBtnClick(data, controller.text),
                          title: S.of(context).send),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppBar().preferredSize.height,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
