import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen_controller.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';
import 'package:homely/utils/url_res.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyLocation extends StatelessWidget {
  final PropertyDetailScreenController controller;

  const PropertyLocation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    PropertyData? data = controller.propertyData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyHeading(title: S.of(context).propertyLocation),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.isMapVisible ? MapCardCustom(data: data) : const SizedBox(height: 160),
              const SizedBox(height: 5),
              Text(
                controller.propertyData?.address ?? '',
                style: MyTextStyle.productLight(color: ColorRes.doveGrey, size: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MapCardCustom extends StatefulWidget {
  final PropertyData? data;

  const MapCardCustom({
    super.key,
    required this.data,
  });

  @override
  State<MapCardCustom> createState() => _MapCardCustomState();
}

class _MapCardCustomState extends State<MapCardCustom> {
  String? mapStyle;
  PropertyData? data;

  GoogleMapController? mapController;

  Map<MarkerId, Marker> markers = {};
  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    mapTheme();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MapCardCustom oldWidget) {
    data = widget.data;
    if (data != null) {
      getPropertyLocation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void mapTheme() {
    rootBundle.loadString(AssetRes.googleMapStyle).then((string) {
      mapStyle = string;
    });
    setState(() {});
  }

  void getPropertyLocation() async {
    latitude = double.parse(data?.latitude ?? '0');
    longitude = double.parse(data?.longitude ?? '0');
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    )));

    var marker = Marker(
      markerId: const MarkerId('0'),
      position: LatLng(latitude, longitude),
      // icon: BitmapDescriptor.bytes(markIcons),
    );
    markers[const MarkerId('0')] = marker;
    setState(() {});
  }

  // declared method to get Images
  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 14.4746,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              style: mapStyle,
              markers: markers.values.toSet(),
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
          InkWell(
            onTap: () async {
              if (latitude != 0) {
                if (Platform.isAndroid) {
                  String googleUrl = UrlRes.googleMapUrl(latitude, longitude);
                  if (await canLaunchUrl(Uri.parse(googleUrl))) {
                    await launchUrl(Uri.parse(googleUrl));
                  } else {
                    throw 'Could not open the map.';
                  }
                } else {
                  String iosUrl = UrlRes.appleMapUrl(latitude, longitude);
                  if (await canLaunchUrl(Uri.parse(iosUrl))) {
                    await launchUrl(Uri.parse(iosUrl));
                  } else {
                    throw 'Could not open the map.';
                  }
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: latitude != 0 ? ColorRes.royalBlue : ColorRes.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: FittedBox(
                child: Row(
                  children: [
                    const Icon(
                      Icons.assistant_navigation,
                      color: ColorRes.white,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      S.of(context).navigate,
                      style: MyTextStyle.productRegular(
                        color: ColorRes.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
