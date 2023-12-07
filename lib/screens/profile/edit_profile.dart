import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moovie/models/user_model.dart';
import 'package:moovie/services/user_notifier.dart';

import '../../providers/providers.dart';
import '../auth/widgets/input.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userStream = ref.watch(userStreamProvider);
    final userService = ref.read(userServiceProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(size: 35.sp, color: Colors.white),
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: userStream.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Color(0xffec5500),
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        data: (data) {
          final UserModel user = data[0]!;
          nameController.text = user.name!;
          emailController.text = user.email!;
          if (user.about != null) {
            bioController.text = user.about!;
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                40.verticalSpace,
                CustomInput(
                  controller: nameController,
                  hintText: "Name",
                ),
                20.verticalSpace,
                CustomInput(
                  controller: emailController,
                  hintText: "Email",
                ),
                20.verticalSpace,
                CustomInput(
                  controller: bioController,
                  hintText: "About Yourself",
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
                    await userService.updateProfile(
                        name: nameController.text,
                        bio: bioController.text,
                        email: emailController.text,
                        context: context,
                        ref: ref);
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
          );
        },
      ),
    );
  }
}
