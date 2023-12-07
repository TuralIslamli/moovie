import 'package:flutter/foundation.dart';
import '../models/movie/movie.dart';

class PageIndex {
  final List<Movie>? movies;
  final int? page;
  final String? errorMessage;

  PageIndex({this.movies, this.page, this.errorMessage});

  PageIndex.initial()
      : movies = [],
        errorMessage = "",
        page = 1;

  bool get refreshError => errorMessage != '' && movies!.length <= 20;
  PageIndex copyWith({
    List<Movie>? movies,
    int? page,
    String? errorMessage,
  }) {
    return PageIndex(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() =>
      'PageIndex(movies: $movies, page: $page, errorMessage: $errorMessage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PageIndex &&
        listEquals(other.movies, movies) &&
        other.page == page &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => movies.hashCode ^ page.hashCode ^ errorMessage.hashCode;
}
