import 'package:get/get.dart';
import 'package:homely/model/media.dart';

class FloorPlansScreenController extends GetxController {
  List<Media> media;

  List<String> image = [];

  FloorPlansScreenController(this.media);

  @override
  void onReady() {
    getMedia();
    super.onReady();
  }

  void getMedia() {
    for (int i = 0; i < media.length; i++) {
      if (media[i].mediaTypeId == 4) {
        if (media[i].content != null || media[i].content!.isNotEmpty) {
          image.add(media[i].content ?? '');
          update();
        }
      }
    }
  }
}
