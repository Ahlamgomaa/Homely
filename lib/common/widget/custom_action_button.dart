import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:homely/common/widget/label_widget.dart';
import '../../generated/l10n.dart';
import '../../utils/asset_res.dart';
import '../../utils/color_res.dart';

class CustomActionButton extends StatelessWidget {
  final Function(int index) onTap;

  const CustomActionButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SpeedDial(
      icon: Icons.add,
      overlayColor: ColorRes.black,
      backgroundColor: ColorRes.royalBlue,
      activeIcon: Icons.clear,
      children: [
        SpeedDialChild(
          onTap: () => onTap(1),
          labelWidget: Transform.translate(
            offset: Offset(isRtl ? 52 : 0, 0),
            child: LabelWidget(
              image: AssetRes.icReelsIcon,
              title: S.current.addReel,
            ),
          ),
        ),
        SpeedDialChild(
          onTap: () => onTap(2),
          labelWidget: Transform.translate(
            offset: Offset(isRtl ? 52 : 0, 0),
            child: LabelWidget(
              image: AssetRes.homeDashboardIcon,
              title: S.current.addProperty,
            ),
          ),
        ),
        SpeedDialChild(
          onTap: () => onTap(3),
          labelWidget: Transform.translate(
            offset: Offset(isRtl ? 52 : 0, 0),
            child: LabelWidget(
              icon: FontAwesomeIcons.whatsapp,
              title: S.current.whatsapp,
            ),
          ),
        ),
      ],
    );
  }
}
