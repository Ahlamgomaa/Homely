import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/tab_list_horizontal.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/faqs.dart';
import 'package:homely/screen/faqs_screen/faqs_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FAQsScreenController());
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: S.of(context).faqs),
          GetBuilder(
              init: controller,
              builder: (controller) {
                return Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: controller.faqsData?.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      bool isSelected = controller.selectedFaqs == index;
                      return InkWell(
                        onTap: () => controller.onFaqsTap(index),
                        child: TabListHorizontal(
                          title: controller.faqsData?[index].title ?? '',
                          isSelected: isSelected,
                        ),
                      );
                    },
                  ),
                );
              }),
          Expanded(
              child: GetBuilder(
            init: controller,
            builder: (controller) => ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.faqsData?[controller.selectedFaqs].faqs?.length,
                itemBuilder: (context, index) {
                  FAQs? faqs = controller.faqsData?[controller.selectedFaqs].faqs?[index];
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(15),
                    color: ColorRes.snowDrift,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          faqs?.question ?? '',
                          style: MyTextStyle.productBold(size: 16, color: ColorRes.charcoalGrey),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          faqs?.answer ?? '',
                          style: MyTextStyle.productLight(size: 16, color: ColorRes.mediumGrey),
                        ),
                      ],
                    ),
                  );
                }),
          ))
        ],
      ),
    );
  }
}
