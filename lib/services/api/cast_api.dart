import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../const/constants.dart';
import '../../models/cast/cast.dart';
import '../../models/cast/cast_model.dart';

Future<List<Cast>?> getMovieCast(String movieId) async {
  final url =
      "https://api.themoviedb.org/3/movie/${movieId.toString()}/credits$apiKey";
  try {
    final res = await Dio().get(url);
    if (res.statusCode == 200) {
      List<Cast>? castList = CastModel.fromJson(res.data).castList;

      return castList;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return [];
}
