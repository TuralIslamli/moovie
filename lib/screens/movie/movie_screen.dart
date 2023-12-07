import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moovie/models/cast/cast.dart';
import 'package:moovie/screens/movie/player_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../services/api/cast_api.dart';
import '../../services/user_notifier.dart';

class MovieScreen extends ConsumerStatefulWidget {
  final String? id;
  final String? title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final String? voteAverage;
  final String? genreView;
  final List<String>? genres;
  final List<int>? genreIds;
  final String? voteCount;
  final String? videoId;

  final StateProvider<bool> isPlayed = StateProvider<bool>((ref) => false);
  final StateProvider<int> viewsProvider = StateProvider<int>((ref) => 0);
  MovieScreen(
      {required this.id,
      required this.videoId,
      required this.title,
      required this.overview,
      required this.voteCount,
      required this.posterPath,
      required this.backdropPath,
      required this.releaseDate,
      required this.voteAverage,
      required this.genreView,
      required this.genreIds,
      required this.genres,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userService = ref.read(userServiceProvider.notifier);
    final likeStream = ref.watch(likeStreamProvider);
    final castFuture = getMovieCast(widget.id!);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(size: 35.sp, color: Colors.white),
        centerTitle: false,
        title: Text(
          widget.title!,
          maxLines: 2,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, left: 4.w, right: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        image: CachedNetworkImageProvider(widget.backdropPath!),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (builder) => PlayerScreen(
                              backdropPath: widget.backdropPath,
                              title: widget.title,
                              controller: YoutubePlayerController(
                                initialVideoId: widget.videoId!,
                                flags: const YoutubePlayerFlags(
                                  autoPlay: true,
                                  mute: false,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_circle_outlined),
                      iconSize: 80.sp,
                      color: const Color(0xffff7d27),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 20.sp,
                                color: const Color(0xffff7d27),
                              ),
                              3.horizontalSpace,
                              Text(
                                "Rating: ${widget.voteAverage}/10",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons.play_arrow_rounded,
                                size: 25.sp,
                                color: const Color(0xffff7d27),
                              ),
                              3.horizontalSpace,
                              Text(
                                "Views: ${(int.tryParse(widget.voteCount!)! + 19766).toString()}",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    5.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        likeStream.when(data: (data) {
                          bool? isLiked = data.docs
                              .any((e) => e.id == widget.id.toString());
                          return InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async => await userService.likeMovie(
                              id: widget.id!,
                              title: widget.title!,
                              posterPath: widget.posterPath!,
                              backdropPath: widget.backdropPath!,
                              releaseDate: widget.releaseDate!,
                              overview: widget.overview!,
                              voteAverage: widget.voteAverage!,
                              voteCount: widget.voteCount!,
                              videoId: widget.videoId!,
                              genreIds: widget.genreIds!,
                              genres: widget.genres!,
                              genreView: widget.genreView!,
                            ),
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 25.sp,
                                    color: const Color(0xffff7d27),
                                  ),
                                  3.horizontalSpace,
                                  Text(
                                    isLiked ? "Unlike" : "Like",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }, error: (error, stackTrace) {
                          return Center(
                            child: Text(error.toString()),
                          );
                        }, loading: () {
                          return const SizedBox();
                        }),
                        SizedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 20.sp,
                                color: const Color(0xffff7d27),
                              ),
                              3.horizontalSpace,
                              Text(
                                widget.releaseDate!,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    5.verticalSpace,
                    Text(
                      widget.genreView!,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    const Divider(
                      thickness: 2,
                      color: Color(0xffff7d27),
                    ),
                    Row(
                      children: [
                        Text(
                          "•",
                          style: TextStyle(
                              fontSize: 30.sp,
                              color: const Color(0xffff7d27),
                              fontWeight: FontWeight.w900),
                        ),
                        5.horizontalSpace,
                        Text(
                          "Overview",
                          style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    3.verticalSpace,
                    Text(
                      widget.overview!,
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500),
                    ),
                    5.verticalSpace,
                    Row(
                      children: [
                        Text(
                          "•",
                          style: TextStyle(
                              fontSize: 30.sp,
                              color: const Color(0xffff7d27),
                              fontWeight: FontWeight.w900),
                        ),
                        5.horizontalSpace,
                        Text(
                          "Cast",
                          style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500),
                        ),
                        5.horizontalSpace,
                        Icon(
                          Icons.arrow_right,
                          size: 30.sp,
                        )
                      ],
                    ),
                    3.verticalSpace,
                    SizedBox(
                      height: 120.h,
                      child: FutureBuilder(
                        future: castFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Cast cast = snapshot.data![index];
                                return SizedBox(
                                  width: 110.w,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 45.r,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  cast.profilePath!),
                                        ),
                                        3.verticalSpace,
                                        Text(
                                          cast.name!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey.shade900,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                    30.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
