// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moovie/screens/auth/login/login_screen.dart';
import 'package:moovie/screens/auth/widgets/input.dart';
import 'package:moovie/services/auth_service.dart';
import '../../../providers/providers.dart';
import '../../../services/user_notifier.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  20.verticalSpace,
                  SizedBox(
                    width: 0.8.sw,
                    child: Image.asset(
                      "assets/moovie-logo.png",
                    ),
                  ),
                  20.verticalSpace,
                  CustomInput(hintText: "Name", controller: nameController),
                  15.verticalSpace,
                  CustomInput(hintText: "Email", controller: emailController),
                  15.verticalSpace,
                  CustomInput(
                      hintText: "Password", controller: passwordController),
                  10.verticalSpace,
                  Text(
                    ref.watch(signUpErrorProvider),
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.w400),
                  ),
                  10.verticalSpace,
                  InkWell(
                    onTap: () async {
                      await ref
                          .watch(userServiceProvider.notifier)
                          .signUpWithEmailPassword(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              context: context,
                              ref: ref);

                      if (ref.watch(signUpSuccessProvider)) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (builder) =>
                                    const AuthServiceListener()),
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
                        "Continue",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have account ?",
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (builder) => const LoginScreen()),
                          );
                        },
                        child: Text(
                          "Sign in here",
                          style: TextStyle(
                            fontSize: 17.sp,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
