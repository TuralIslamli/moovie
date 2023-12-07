// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moovie/screens/auth/widgets/input.dart';
import 'package:moovie/screens/profile/profile_screen.dart';
import 'package:moovie/services/user_notifier.dart';

import '../../providers/providers.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController retryNewPassController = TextEditingController();
  @override
  void dispose() {
    oldPassController.dispose();
    newPassController.dispose();
    retryNewPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userService = ref.read(userServiceProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(size: 35.sp, color: Colors.white),
        centerTitle: true,
        title: Text(
          "Reset Password",
          style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Column(
          children: [
            70.verticalSpace,
            CustomInput(
              controller: oldPassController,
              hintText: "Old Password",
            ),
            20.verticalSpace,
            CustomInput(
              controller: newPassController,
              hintText: "New Password",
            ),
            20.verticalSpace,
            CustomInput(
              controller: retryNewPassController,
              hintText: "Retry New Password",
            ),
            15.verticalSpace,
            Text(
              ref.watch(authErrorProvider),
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.w400),
            ),
            15.verticalSpace,
            InkWell(
              onTap: () async {
                await userService.resetPassword(
                    oldPass: oldPassController.text,
                    newPass: newPassController.text,
                    retryNewPass: retryNewPassController.text,
                    context: context,
                    ref: ref);
                if (ref.watch(passResetSuccesProvider)) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (builder) => const ProfileScreen()),
                      (route) => false);
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 55.h,
                decoration: BoxDecoration(
                  color: const Color(0xffec5500),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
