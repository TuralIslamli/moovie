// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moovie/screens/movie/movie_screen.dart';

import '../../../models/movie/movie.dart';
import '../../../services/api/exclusive_api.dart';

class ExclusiveMovies extends ConsumerWidget {
  const ExclusiveMovies({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: getExclusiveMovies(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            width: double.infinity,
            child: CarouselSlider.builder(
              itemCount: 10,
              options: CarouselOptions(
                autoPlay: true,
                height: 180.h,
                viewportFraction: 0.91.w,
                enlargeCenterPage: true,
                autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
                autoPlayAnimationDuration: const Duration(seconds: 2),
              ),
              itemBuilder: (context, index, realIndex) {
                Movie movie = snapshot.data![index];
                return InkWell(
                  onTap: () async {
                    String videoId = await movie.getVideoIds(movie.id!);
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (builder) {
                          return MovieScreen(
                            id: movie.id,
                            title: movie.title,
                            overview: movie.overview,
                            posterPath: movie.posterPath,
                            backdropPath: movie.backdropPath,
                            releaseDate: movie.releaseDate,
                            voteAverage: movie.voteAverage,
                            genres: movie.genres,
                            genreIds: movie.genreIds,
                            genreView: movie.genreView,
                            voteCount: movie.voteCount,
                            videoId: videoId,
                          );
                        },
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(15.r),
                          image: DecorationImage(
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(
                              movie.backdropPath!,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        width: double.infinity,
                        height: 65.h,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black,
                                ]),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.r),
                              bottomRight: Radius.circular(15.r),
                            )),
                        child: Text(
                          movie.title!,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.grey.shade100,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Positioned(
                        top: 11.h,
                        left: 0,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 5.h),
                          width: 70.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: const Color(0xffff7d27),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.r),
                              bottomRight: Radius.circular(15.r),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                                size: 19.sp,
                              ),
                              5.horizontalSpace,
                              Text(
                                movie.releaseDate!.split("-")[0],
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.grey.shade100,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: 4.h,
                          right: 0,
                          child: SizedBox(
                            width: 150.w,
                            child: Image.asset(
                              "assets/exclusive.png",
                              fit: BoxFit.contain,
                            ),
                          )),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
            ),
          );
        }
      },
    );
  }
}
