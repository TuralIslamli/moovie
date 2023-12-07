import 'package:moovie/models/movie/movie.dart';

class MovieModel {
  int? page;
  int? totalPage;
  int? totalResults;
  List<Movie>? movies = [];

  MovieModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalResults = json["total_results"];
    totalPage = json["total_pages"];

    List<Movie> movieList = [];
    for (int i = 0; i < json["results"].length; i++) {
      Movie movie = Movie(json["results"][i]);
      movieList.add(movie);
    }
    movies = movieList;
  }
}
