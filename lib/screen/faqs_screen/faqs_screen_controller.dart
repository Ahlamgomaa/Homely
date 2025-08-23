import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/model/faqs.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/utils/url_res.dart';

class FAQsScreenController extends GetxController {
  int selectedFaqs = 0;
  List<FaqsData>? faqsData;

  void onFaqsTap(int index) {
    selectedFaqs = index;
    update();
  }

  @override
  void onReady() {
    fetchFaqsApiCall();
    super.onReady();
  }

  void fetchFaqsApiCall() {
    CommonUI.loader();
    ApiService().call(
      url: UrlRes.fetchFAQs,
      completion: (response) {
        Get.back();
        faqsData = Faqs.fromJson(response).data;
        update();
      },
    );
  }
}
