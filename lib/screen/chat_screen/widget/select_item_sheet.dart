import 'package:flutter/material.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SelectItemSheet extends StatelessWidget {
  final Function(int) onTap;

  const SelectItemSheet({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: ColorRes.whiteSmoke,
          ),
          child: Text(
            S.of(context).selectItem,
            style: MyTextStyle.productRegular(size: 24),
          ),
        ),
        Container(
          color: ColorRes.white,
          child: GridView.count(
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.all(15),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 1.9,
            children: <Widget>[
              TextWithDivider(
                  onTap: () {
                    onTap(1);
                  },
                  title: S.of(context).selectProperty,
                  image: AssetRes.icBuilding),
              TextWithDivider(
                  onTap: () {
                    onTap(2);
                  },
                  title: S.of(context).selectMedia,
                  image: AssetRes.icPicture),
              TextWithDivider(
                  onTap: () {
                    onTap(3);
                  },
                  title: S.of(context).captureImage,
                  image: AssetRes.icCamera),
              TextWithDivider(
                  onTap: () {
                    onTap(4);
                  },
                  title: S.of(context).captureVideo,
                  image: AssetRes.icVideoCamera),
            ],
          ),
        )
      ],
    );
  }
}

class SelectMediaSheet extends StatelessWidget {
  final Function(int) onTap;

  const SelectMediaSheet({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: ColorRes.whiteSmoke,
          ),
          child: Text(
            S.of(context).selectItem,
            style: MyTextStyle.productRegular(size: 24),
          ),
        ),
        Container(
          color: ColorRes.white,
          child: GridView.count(
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.all(15),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 1.9,
            children: <Widget>[
              TextWithDivider(
                  onTap: () {
                    onTap(1);
                  },
                  title: S.of(context).selectImage,
                  image: AssetRes.icCamera),
              TextWithDivider(
                  onTap: () {
                    onTap(2);
                  },
                  title: S.of(context).selectVideo,
                  image: AssetRes.icVideoCamera),
            ],
          ),
        )
      ],
    );
  }
}

class TextWithDivider extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const TextWithDivider(
      {super.key,
      required this.title,
      required this.onTap,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 50,
            height: 50,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            style:
                MyTextStyle.productMedium(size: 16, color: ColorRes.daveGrey),
          )
        ],
      ),
    );
  }
}
