import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/constants.dart';
import '../../models/movie/movie.dart';
import '../../models/movie/movie_model.dart';
import '../page_index.dart';

class PopularNotifier extends StateNotifier<PageIndex> {
  PopularNotifier([PageIndex? state]) : super(state ?? PageIndex.initial()) {
    getMovies();
  }

  Future<List<Movie>?> fetchMovies([int page = 2]) async {
    const String baseUrl = "https://api.themoviedb.org/3/movie/now_playing";

    final String url = "$baseUrl$apiKey&page=$page";

    try {
      final res = await Dio().get(url);
      if (res.statusCode == 200) {
        List<Movie> movies = MovieModel.fromJson(res.data).movies!;

        return movies;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<void> getMovies() async {
    try {
      final movies = await fetchMovies(state.page!);

      state = state.copyWith(
          movies: [...?state.movies, ...?movies], page: state.page! + 1);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void handleScrollWithIndex(int index) {
    final itemPosition = index + 1;
    final requestMoreData = itemPosition % 20 == 0 && itemPosition != 0;
    final pageToRequest = itemPosition ~/ 20;

    if (requestMoreData && pageToRequest + 2 >= state.page!) {
      getMovies();
    }
  }

  Future<void> stateClear() async {
    state = state.copyWith(movies: [], page: 2);
    await getMovies();
  }
}

final popularNotifier = StateNotifierProvider<PopularNotifier, PageIndex>(
    (ref) => PopularNotifier());
