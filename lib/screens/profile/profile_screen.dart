// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moovie/models/user_model.dart';
import 'package:moovie/providers/providers.dart';
import 'package:moovie/screens/profile/change_password.dart';
import 'package:moovie/screens/profile/edit_profile.dart';
import 'package:moovie/screens/widgets/bottom_bar.dart';
import '../../services/auth_service.dart';
import '../../services/user_notifier.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User user = FirebaseAuth.instance.currentUser!;
    final userStream = ref.watch(userStreamProvider);
    final userService = ref.read(userServiceProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(size: 35.sp, color: Colors.white),
        centerTitle: true,
        title: Text(
          user.displayName!,
          style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                child: userStream.when(
                    loading: () => const SizedBox(),
                    error: (error, stackTrace) => Text(error.toString()),
                    data: (data) {
                      if (data[0] != null) {
                        final UserModel user = data[0]!;
                        return Column(
                          children: [
                            Container(
                              width: 160.w,
                              height: 160.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color(0xffec5500),
                                      width: 6.w)),
                              child: ref.watch(uploadPictureProvider)
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      color: Color(0xffec5500),
                                    ))
                                  : Stack(
                                      children: [
                                        data[0] != null
                                            ? SizedBox(
                                                width: 160,
                                                height: 160,
                                                child: user.avatar != null
                                                    ? CircleAvatar(
                                                        backgroundImage:
                                                            CachedNetworkImageProvider(
                                                          user.avatar!,
                                                        ),
                                                      )
                                                    : null)
                                            : const SizedBox(),
                                      ],
                                    ),
                            ),
                            10.verticalSpace,
                            data[0] != null && user.about != null
                                ? Text(
                                    user.about!,
                                    maxLines: 4,
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w400),
                                  )
                                : const SizedBox(),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => const EditProfileScreen()));
                    },
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60.h,
                      child: Card(
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.grey.shade900,
                        elevation: 5,
                        child: Row(
                          children: [
                            15.horizontalSpace,
                            Icon(
                              Icons.edit,
                              size: 30.sp,
                              color: Colors.grey.shade800,
                            ),
                            10.horizontalSpace,
                            Text(
                              "Edit Profile",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  7.verticalSpace,
                  InkWell(
                    onTap: () async {
                      await userService.changeAvatar(ref);
                    },
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60.h,
                      child: Card(
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.grey.shade900,
                        elevation: 5,
                        child: Row(
                          children: [
                            15.horizontalSpace,
                            Icon(
                              Icons.camera_alt,
                              size: 30.sp,
                              color: Colors.grey.shade800,
                            ),
                            10.horizontalSpace,
                            Text(
                              "Change Avatar",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  7.verticalSpace,
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => const ChangePasswordScreen()));
                    },
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60.h,
                      child: Card(
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.grey.shade900,
                        elevation: 5,
                        child: Row(
                          children: [
                            15.horizontalSpace,
                            Icon(
                              Icons.lock,
                              size: 30.sp,
                              color: Colors.grey.shade800,
                            ),
                            10.horizontalSpace,
                            Text(
                              "Reset Password",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  7.verticalSpace,
                  InkWell(
                    onTap: () {},
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60.h,
                      child: Card(
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.grey.shade900,
                        elevation: 5,
                        child: Row(
                          children: [
                            15.horizontalSpace,
                            Icon(
                              Icons.favorite,
                              size: 30.sp,
                              color: Colors.grey.shade800,
                            ),
                            10.horizontalSpace,
                            Text(
                              "Liked Movies",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  7.verticalSpace,
                  InkWell(
                    onTap: () async {
                      showDialog(
                          context: (context),
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.r),
                                ),
                              ),
                              title: Text(
                                "Are You Sure?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              content: Center(
                                child: Column(
                                  children: [
                                    const Divider(
                                      thickness: 2,
                                    ),
                                    Text(
                                      "If you delete your account, you will lose:",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    5.verticalSpace,
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "• Your email & password",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    5.verticalSpace,
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "• Your profile picture",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    5.verticalSpace,
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "• Your Liked Movies list",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 2,
                                    ),
                                  ],
                                ),
                              ),
                              contentPadding: EdgeInsets.all(20.w),
                              actionsPadding: EdgeInsets.all(20.w),
                              insetPadding: EdgeInsets.symmetric(
                                  vertical: 0.23.sh, horizontal: 0.1.sw),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 100.w,
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffec5500),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Text(
                                          "Don't Delete",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await userService
                                            .deleteProfile(context);
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  const AuthServiceListener()),
                                          (route) => false,
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 100.w,
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          color: const Color(0xfff7bb99),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Text(
                                          "Yes, Delete",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60.h,
                      child: Card(
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.grey.shade900,
                        elevation: 5,
                        child: Row(
                          children: [
                            15.horizontalSpace,
                            Icon(
                              Icons.delete_forever,
                              size: 30.sp,
                              color: Colors.grey.shade800,
                            ),
                            10.horizontalSpace,
                            Text(
                              "Delete Account",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  7.verticalSpace,
                  InkWell(
                    onTap: () async {
                      await userService.logOut(context);
                    },
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60.h,
                      child: Card(
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.grey.shade900,
                        elevation: 5,
                        child: Row(
                          children: [
                            15.horizontalSpace,
                            Icon(
                              Icons.exit_to_app,
                              size: 30.sp,
                              color: Colors.grey.shade800,
                            ),
                            10.horizontalSpace,
                            Text(
                              "Logout",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
