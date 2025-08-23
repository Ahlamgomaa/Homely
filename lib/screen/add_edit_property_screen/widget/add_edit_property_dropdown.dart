import 'package:flutter/material.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class AddEditPropertyDropDown extends StatelessWidget {
  final List<dynamic> list;
  final dynamic value;
  final Function(dynamic value) onChanged;
  final bool isResident;

  const AddEditPropertyDropDown({
    super.key,
    required this.list,
    this.value,
    required this.onChanged,
    this.isResident = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      foregroundDecoration: !isResident
          ? BoxDecoration(
              color: ColorRes.whiteSmoke.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(10),
            )
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration:
          BoxDecoration(color: ColorRes.whiteSmoke, borderRadius: BorderRadius.circular(10)),
      child: DropdownButton<dynamic>(
        value: value,
        isExpanded: true,
        iconEnabledColor: ColorRes.royalBlue,
        icon: const Icon(Icons.arrow_drop_down_rounded),
        iconSize: 30,
        menuMaxHeight: 150,
        borderRadius: BorderRadius.circular(10),
        style: MyTextStyle.productRegular(size: 15, color: ColorRes.mediumGrey),
        underline: const SizedBox(),
        hint: Text(
          S.of(context).select,
        ),
        onChanged: isResident ? onChanged : null,
        items: list.map<DropdownMenuItem<dynamic>>((dynamic value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
