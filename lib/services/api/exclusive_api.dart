import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../const/constants.dart';
import '../../models/movie/movie.dart';
import '../../models/movie/movie_model.dart';

Future<List<Movie>?> getExclusiveMovies([int page = 1]) async {
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
