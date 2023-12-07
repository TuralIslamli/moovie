// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moovie/models/movie/movie.dart';
import 'package:moovie/services/providers/popular_notifier.dart';

import '../../movie/movie_screen.dart';

class PopularMovies extends ConsumerWidget {
  const PopularMovies({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(popularNotifier);
    return Builder(builder: (context) {
      if (state.refreshError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.errorMessage!),
              ElevatedButton(
                onPressed: () =>
                    ref.read(popularNotifier.notifier).fetchMovies(),
                child: const Text("Try again"),
              ),
            ],
          ),
        );
      } else if (state.movies!.isEmpty) {
        return Container(
          margin: EdgeInsets.only(top: 0.3.sh),
          width: 50.w,
          height: 50.w,
          child: const Align(
            alignment: Alignment.topCenter,
            child: CircularProgressIndicator(
              color: Color(0xffff7d27),
            ),
          ),
        );
      }
      return RefreshIndicator(
        color: const Color(0xffff7d27),
        onRefresh: () {
          ref.read(popularNotifier.notifier).stateClear();
          return ref.read(popularNotifier.notifier).fetchMovies();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 5.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150.w,
              crossAxisSpacing: 5.w,
              mainAxisSpacing: 3.w,
              childAspectRatio: 0.6,
            ),
            itemCount: state.movies!.length,
            itemBuilder: (context, index) {
              ref.read(popularNotifier.notifier).handleScrollWithIndex(index);
              Movie movie = state.movies![index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
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
                      children: [
                        Container(
                          height: 170.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(15.r),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              image: CachedNetworkImageProvider(
                                movie.posterPath!,
                              ),
                              // : const AssetImage("assets/nullPoster.jpg"),
                            ),
                          ),
                        ),
                        if (movie.genres.isNotEmpty)
                          Positioned(
                            top: 11.h,
                            left: 0,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  left: 1.w, right: 4.w, top: 2.h, bottom: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xffff7d27),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15.r),
                                  bottomRight: Radius.circular(15.r),
                                ),
                              ),
                              child: Text(
                                movie.genres[0],
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
                        else
                          Positioned(
                              top: 11.h, left: 0, child: const SizedBox()),
                        if (movie.releaseDate!.split("-").isNotEmpty)
                          Positioned(
                            top: 11.h,
                            right: 0,
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: 4.w,
                                    right: 1.w,
                                    top: 2.h,
                                    bottom: 2.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xffff7d27),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.r),
                                    bottomLeft: Radius.circular(15.r),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      size: 11.sp,
                                      color: Colors.white,
                                    ),
                                    2.horizontalSpace,
                                    Text(
                                      movie.releaseDate!.split("-")[0],
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ],
                                )),
                          )
                        else
                          Positioned(
                              top: 11.h, right: 0, child: const SizedBox()),
                        Positioned(
                          bottom: 0.w,
                          left: 0.w,
                          right: 0.w,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 5.w, right: 5.w, bottom: 7.h, top: 7.h),
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15.r),
                                bottomRight: Radius.circular(15.r),
                              ),
                            ),
                            child: Text(
                              movie.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    });
  }
}
