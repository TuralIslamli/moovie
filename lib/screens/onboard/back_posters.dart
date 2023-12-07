import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:moovie/const/constants.dart';

class BackPosters extends StatelessWidget {
  const BackPosters({super.key});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posterList.length,
      crossAxisCount: 3,
      mainAxisSpacing: 5.w,
      crossAxisSpacing: 5.w,
      padding: EdgeInsets.all(5.w),
      itemBuilder: (context, index) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.asset(posterList[index]));
      },
    );
  }
}
