import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/features/main_home/widgets/card_link.dart';

class LinksList extends StatefulWidget {
  const LinksList({super.key});

  @override
  State<LinksList> createState() => _LinksListState();
}

class _LinksListState extends State<LinksList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsetsDirectional.only(
        bottom: MediaQuery.of(context).size.height * 0.18.h,
      ),
      itemCount: 2,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        return CardLink(
          name: 'حساب الجيت هب',
          icon: AssetsApp.google,
          link: 'www.github.com',
        );
      },
    );
  }
}
