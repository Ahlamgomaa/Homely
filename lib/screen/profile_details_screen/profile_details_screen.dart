import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_dropdown.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_heading.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_textfield.dart';
import 'package:homely/screen/profile_details_screen/profile_details_screen_controller.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';

class ProfileDetailsScreen extends StatelessWidget {
  final Function(int type, UserData? userData)? onUpdate;

  const ProfileDetailsScreen({super.key, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileDetailScreenController(onUpdate));
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBarArea(title: S.of(context).profileDetails),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: GetBuilder(
                  init: controller,
                  builder: (controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            InkWell(
                              onTap: controller.onProfileClick,
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: ClipOval(
                                  child: controller.fileImage != null
                                      ? Image.file(
                                          File(controller.fileImage?.path ?? ''),
                                          fit: BoxFit.cover,
                                        )
                                      : controller.networkImage != null
                                          ? Image.network(
                                              '${controller.networkImage}'.image,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return CommonUI.errorUserPlaceholder(width: 100, height: 100);
                                              },
                                            )
                                          : CommonUI.errorUserPlaceholder(width: 100, height: 100),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: controller.onProfileClick,
                              child: Container(
                                height: 28,
                                width: 28,
                                padding: const EdgeInsets.all(7),
                                decoration: const BoxDecoration(
                                  color: ColorRes.royalBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(AssetRes.editProfileIcon),
                              ),
                            )
                          ],
                        ),
                        AddEditPropertyHeading(title: S.of(context).fullname),
                        AddEditPropertyTextField(
                          controller: controller.fullnameController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        AddEditPropertyHeading(title: S.of(context).whatAreYouHereFor),
                        AddEditPropertyDropDown(
                          list: controller.hereFor,
                          onChanged: controller.onTypeChange,
                          value: controller.userType,
                        ),
                        AddEditPropertyHeading(title: S.of(context).aboutYourself),
                        AddEditPropertyTextField(
                          controller: controller.aboutController,
                          isExpand: true,
                          textInputType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        AddEditPropertyHeading(title: S.of(context).addressOptional),
                        AddEditPropertyTextField(
                          controller: controller.addressController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        AddEditPropertyHeading(title: S.of(context).phoneOfficeOptional),
                        AddEditPropertyTextField(
                          controller: controller.phoneOfficeController,
                          textInputType: TextInputType.phone,
                        ),
                        AddEditPropertyHeading(title: S.of(context).mobileOptional),
                        AddEditPropertyTextField(
                          controller: controller.mobileController,
                          textInputType: TextInputType.phone,
                        ),
                        AddEditPropertyHeading(title: S.of(context).faxOptional),
                        AddEditPropertyTextField(
                          controller: controller.faxController,
                          textInputType: TextInputType.phone,
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          SafeArea(top: false, child: TextButtonCustom(onTap: controller.onSubmitClick, title: S.of(context).submit))
        ],
      ),
    );
  }
}
