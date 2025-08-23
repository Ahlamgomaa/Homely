import 'package:flutter/material.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/utils/asset_res.dart';

class VerifiedIconCustom extends StatelessWidget {
  final bool isWhiteIcon;
  final double size;
  final UserData? userData;

  const VerifiedIconCustom({super.key, this.isWhiteIcon = false, this.size = 20, required this.userData});

  @override
  Widget build(BuildContext context) {
    return userData?.verificationStatus == 2 || userData?.verificationStatus == 3
        ? Row(
            children: [
              const SizedBox(width: 5),
              Image.asset(
                isWhiteIcon ? AssetRes.icVerificationWhite : AssetRes.icVerification,
                height: size,
                width: size,
              ),
            ],
          )
        : const SizedBox();
  }
}
