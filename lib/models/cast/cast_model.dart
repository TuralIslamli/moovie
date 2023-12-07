import 'package:moovie/models/cast/cast.dart';

class CastModel {
  int? movieId;
  List<Cast>? castList;

  CastModel.fromJson(Map<String, dynamic> json) {
    movieId = json['id'];

    List<Cast> casts = [];
    for (int i = 0; i < json["cast"].length; i++) {
      Cast cast = Cast(json["cast"][i]);
      casts.add(cast);
    }
    castList = casts;
  }
}
