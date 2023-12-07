import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moovie/providers/providers.dart';
import 'package:moovie/screens/home/home_screen.dart';
import 'package:moovie/screens/profile/profile_screen.dart';
import 'package:moovie/screens/search/search_screen.dart';

class BottomBar extends ConsumerWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(selectedIndex);
    final changeIndex = ref.read(selectedIndex.notifier);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              changeIndex.update((state) => 0);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (builder) => const HomeScreen()));
            },
            icon: Icon(
              index == 0 ? Icons.other_houses : Icons.other_houses_outlined,
              size: 35.sp,
              color:
                  index == 0 ? const Color(0xffff7d27) : Colors.amber.shade700,
            ),
          ),
          IconButton(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              changeIndex.update((state) => 1);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => const SearchScreen()));
            },
            icon: Icon(
              Icons.manage_search_rounded,
              size: 35.sp,
              color:
                  index == 1 ? const Color(0xffff7d27) : Colors.amber.shade700,
            ),
          ),
          IconButton(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              changeIndex.update((state) => 3);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => const ProfileScreen()));
            },
            icon: Icon(
              index == 3 ? Icons.person : Icons.person_outline,
              size: 35.sp,
              color:
                  index == 3 ? const Color(0xffff7d27) : Colors.amber.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
