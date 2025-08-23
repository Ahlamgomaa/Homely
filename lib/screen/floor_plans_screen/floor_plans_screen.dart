import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/media.dart';
import 'package:homely/screen/floor_plans_screen/floor_plans_screen_controller.dart';
import 'package:homely/screen/preview_image_screen/preview_image_screen.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/utils/extension.dart';

class FloorPlansScreen extends StatelessWidget {
  final List<Media> media;

  const FloorPlansScreen({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FloorPlansScreenController(media));
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: S.of(context).floorPlans),
          Expanded(
            child: SafeArea(
              top: false,
              child: GetBuilder(
                  init: controller,
                  builder: (controller) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.image.length,
                      itemBuilder: (context, index) {
                        String m = controller.image[index];

                        return InkWell(
                          onTap: () => NavigateService.push(
                            context,
                            PreviewImageScreen(
                              image: m,
                              screenType: 0,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: Image.network(
                              (m).image,
                              width: double.infinity,
                              height: 292,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
