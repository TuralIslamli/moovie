import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../const/constants.dart';
import '../../models/movie/movie.dart';
import '../../models/movie/movie_model.dart';

FutureOr<List<Movie?>> searchMovie(String searchQuery) async {
  String url =
      "https://api.themoviedb.org/3/search/movie$apiKey&query=${searchQuery.toLowerCase()}";
  try {
    final res = await Dio().get(url);
    if (res.statusCode == 200) {
      List<Movie> results = MovieModel.fromJson(res.data).movies!;
      return results;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return [];
}
