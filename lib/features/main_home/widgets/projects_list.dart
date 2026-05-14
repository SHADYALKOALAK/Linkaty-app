import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/features/main_home/widgets/card_project.dart';

class ProjectsList extends StatelessWidget {
  const ProjectsList({super.key});

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
        return CardProject(
          image: "https://es.celoxis.com/cassets/img/pmc/main-areas-project-management.png",
          title: "مشروع تصميم واجهات المستخدم وعرض احدث $index",
          link: "https://linkaty.com",
        );
      },
    );
  }
}
