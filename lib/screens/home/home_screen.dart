import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moovie/screens/home/widgets/exclusive_movies.dart';
import 'package:moovie/screens/home/widgets/popular_movies.dart';
import 'package:moovie/screens/profile/profile_screen.dart';
import 'package:moovie/screens/search/search_screen.dart';
import 'package:moovie/screens/widgets/bottom_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (builder) => const ProfileScreen())),
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 17.r,
                backgroundImage: CachedNetworkImageProvider(user.photoURL!),
              ),
              10.horizontalSpace,
              Text(
                "Hi, ${user.displayName!}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500),
              ),
              10.horizontalSpace,
              Transform.rotate(
                  angle: -0.35.r,
                  child: Icon(
                    Icons.back_hand,
                    color: const Color(0xffff7d27),
                    size: 22.sp,
                  )),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => const SearchScreen()));
              },
              iconSize: 30.sp,
              color: Colors.white,
              icon: const Icon(Icons.manage_search_rounded)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 5.h),
        child: Column(
          children: [
            const ExclusiveMovies(),
            10.verticalSpace,
            const Expanded(child: PopularMovies()),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
