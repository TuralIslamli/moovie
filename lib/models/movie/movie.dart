import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../const/constants.dart';

class Movie {
  String? id;
  String? title;
  String? backdropPath;
  String? overview;
  String? posterPath;
  String? releaseDate;
  String? voteAverage;
  String? videoId;
  String? voteCount;
  List<int> genreIds = [];
  List<String> genres = [];
  String genreView = "";

  Movie(movie) {
    videoId = "";
    id = movie["id"].toString();
    title = movie["title"];
    voteCount = movie["vote_count"].toString();

    backdropPath =
        "https://image.tmdb.org/t/p/original/${movie["backdrop_path"]}";
    posterPath = movie["poster_path"].toString() != "null"
        ? "https://image.tmdb.org/t/p/w500/${movie["poster_path"]}"
        : "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg";
    overview = movie["overview"] ?? "null";
    releaseDate = movie["release_date"] ?? "null";
    voteAverage =
        double.parse((movie["vote_average"] ?? 0).toDouble().toStringAsFixed(1))
            .toString();

    for (int i = 0; i < movie["genre_ids"].length; i++) {
      genreIds.add(movie["genre_ids"][i]);
    }

    genres = genreConverter(genreIds);

    for (int i = 0; i < genres.length; i++) {
      if (i == 0) {
        genreView = genres[i];
      } else {
        genreView = "$genreView, ${genres[i]}";
      }
    }
  }

  Future<String> getVideoIds(String id) async {
    const String baseUrl = "https://api.themoviedb.org/3/movie/";
    final String videoUrl = "$baseUrl$id/videos$apiKey";
    try {
      final res = await Dio().get(videoUrl);
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        final List results = data["results"];
        final Iterable keyMap = results.map((e) => e["key"]);
        final String key = keyMap.toList()[0];
        return key;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return "";
  }

  List<String> genreConverter(List<int> genres) {
    List<String> genreNames = [];
    genreMap.forEach((key, value) {
      if (genres.contains(value)) {
        genreNames.add(key);
      }
    });
    return genreNames;
  }

  Map<String, dynamic> genreMap = {
    "Action": 28,
    "Adventure": 12,
    "Animation": 16,
    "Comedy": 35,
    "Crime": 80,
    "Documentary": 99,
    "Drama": 18,
    "Family": 10751,
    "Fantasy": 14,
    "History": 36,
    "Horror": 27,
    "Music": 10402,
    "Mystery": 9648,
    "Romance": 10749,
    "Sci-Fi": 878,
    "TV": 10770,
    "Thriller": 53,
    "War": 10752,
    "Western": 37,
  };
}
