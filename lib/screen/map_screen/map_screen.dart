import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/map_screen/map_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class MapScreen extends StatelessWidget {
  final LatLng latLng;

  const MapScreen({
    super.key,
    required this.latLng,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapScreenController(latLng));
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              TopBarArea(title: S.current.mapScreen),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    GoogleMap(
                      onTap: (argument) {
                        controller.getCameraPosition(latLng: argument);
                      },
                      initialCameraPosition: const CameraPosition(target: LatLng(0, 0), zoom: 16),
                      markers: Set<Marker>.of(controller.markers.toSet()),
                      style: controller.mapStyle,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      compassEnabled: false,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      onMapCreated: (GoogleMapController c) {
                        controller.mapController.complete(c);
                      },
                    ),
                    SafeArea(
                      top: false,
                      child: InkWell(
                        onTap: controller.onDoneClick,
                        child: Container(
                          height: 45,
                          width: Get.width / 3,
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(color: ColorRes.royalBlue, borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: SafeArea(
                            top: false,
                            child: Text(
                              S.of(context).done,
                              style: MyTextStyle.productMedium(color: ColorRes.white, size: 16),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: controller.getUserCurrentLocation,
        backgroundColor: ColorRes.royalBlue,
        child: const Icon(
          Icons.location_on,
        ),
      ),
    );
  }
}
