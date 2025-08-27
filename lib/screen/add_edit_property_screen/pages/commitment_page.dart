import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/screen/add_edit_property_screen/add_edit_property_screen_controller.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_heading.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class CommitmentPage extends StatelessWidget {
  final AddEditPropertyScreenController controller;

  const CommitmentPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (controller) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddEditPropertyHeading(title: "الشروط والالتزامات"),
                  const SizedBox(height: 20),

                  // Terms and Conditions Content

                  SingleChildScrollView(
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ColorRes.porcelain,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: ColorRes.osloGrey.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTermSection(
                              title: "1. التزامات المالك",
                              content:
                                  "• تقديم معلومات صحيحة ودقيقة عن العقار\n"
                                  "• المحافظة على حالة العقار الجيدة\n"
                                  "• توفير جميع المرافق والخدمات المذكورة\n"
                                  "• احترام خصوصية المستأجر"),
                          const SizedBox(height: 16),
                          _buildTermSection(
                              title: "2. الشروط المالية",
                              content: "• دفع الإيجار في المواعيد المحددة\n"
                                  "• تحمل تكاليف الصيانة العادية\n"
                                  "• عدم تأخير المدفوعات أكثر من 7 أيام\n"
                                  "• الالتزام بقيمة التأمين المطلوبة"),
                          const SizedBox(height: 16),
                          _buildTermSection(
                              title: "3. قواعد الاستخدام",
                              content:
                                  "• عدم إجراء تعديلات على العقار بدون إذن\n"
                                  "• المحافظة على نظافة العقار\n"
                                  "• عدم التدخين داخل العقار\n"
                                  "• احترام الجيران وعدم إزعاجهم"),
                          const SizedBox(height: 16),
                          _buildTermSection(
                              title: "4. مسؤوليات المستأجر",
                              content: "• الإبلاغ فوراً عن أي أضرار أو مشاكل\n"
                                  "• عدم تأجير العقار من الباطن\n"
                                  "• الحفاظ على أمان العقار\n"
                                  "• إخلاء العقار في حالة جيدة عند انتهاء العقد"),
                          const SizedBox(height: 16),
                          _buildTermSection(
                              title: "5. إنهاء العقد",
                              content: "• إشعار مسبق 30 يوم قبل الإنهاء\n"
                                  "• تسوية جميع المستحقات المالية\n"
                                  "• تسليم العقار في حالة جيدة\n"
                                  "• استرداد التأمين حسب حالة العقار"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Agreement Checkbox
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorRes.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: controller.isTermsAccepted
                              ? ColorRes.royalBlue
                              : ColorRes.osloGrey.withOpacity(0.3),
                          width: 2),
                    ),
                    child: InkWell(
                      onTap: () => controller.toggleTermsAcceptance(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: controller.isTermsAccepted
                                  ? ColorRes.royalBlue
                                  : ColorRes.white,
                              border: Border.all(
                                  color: controller.isTermsAccepted
                                      ? ColorRes.royalBlue
                                      : ColorRes.osloGrey,
                                  width: 2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: controller.isTermsAccepted
                                ? const Icon(
                                    Icons.check,
                                    color: ColorRes.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "أوافق على جميع الشروط والأحكام",
                                  style: MyTextStyle.productMedium(
                                    size: 16,
                                    color: controller.isTermsAccepted
                                        ? ColorRes.royalBlue
                                        : ColorRes.osloGrey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "بالموافقة على هذه الشروط، فإنني ألتزم بجميع البنود المذكورة أعلاه وأتحمل المسؤولية الكاملة عن الالتزام بها.",
                                  style: MyTextStyle.productRegular(
                                    size: 12,
                                    color: ColorRes.osloGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ));
  }

  Widget _buildTermSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: MyTextStyle.productMedium(
            size: 16,
            color: ColorRes.royalBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: MyTextStyle.productRegular(
            size: 14,
            color: ColorRes.osloGrey,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}
