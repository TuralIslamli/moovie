import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../auth/login/login_screen.dart';
import 'back_posters.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: 1.sw,
          height: 1.sh,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              FadeInDown(
                delay: const Duration(milliseconds: 700),
                child: const BackPosters(),
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                child: Container(
                  width: double.infinity,
                  height: 0.27.sh,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/moovie-logo.png",
                        width: 0.7.sw,
                      ),
                      20.verticalSpace,
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (builder) => const LoginScreen()),
                              (route) => false);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 0.75.sw,
                          height: 55.h,
                          decoration: BoxDecoration(
                            color: const Color(0xffec5500),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
