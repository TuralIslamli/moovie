// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:moovie/screens/widgets/bottom_bar.dart';
import 'package:moovie/services/api/search_api.dart';

import '../../models/movie/movie.dart';
import '../movie/movie_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  FocusNode searchFocusNode = FocusNode();
  @override
  void initState() {
    searchFocusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
          child: SizedBox(
            height: 55.h,
            width: double.infinity,
            child: TypeAheadField<Movie?>(
              textFieldConfiguration: TextFieldConfiguration(
                focusNode: searchFocusNode,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(7.r),
                  filled: true,
                  fillColor: Colors.black26,
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey.shade400, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey.shade700, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.red, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.red, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.red, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ),
              debounceDuration: const Duration(milliseconds: 500),
              hideSuggestionsOnKeyboardHide: false,
              hideKeyboardOnDrag: true,
              minCharsForSuggestions: 1,
              onSuggestionsBoxToggle: (p0) {
                p0 = false;
              },
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  constraints: BoxConstraints(
                maxHeight: 0.775.sh,
                minHeight: 0.sh,
              )),
              itemSeparatorBuilder: (context, index) => const Divider(
                thickness: 2,
              ),
              suggestionsCallback: (pattern) async {
                return await searchMovie(pattern);
              },
              itemBuilder: (context, Movie? suggestion) {
                final movie = suggestion!;
                return ListTile(
                  title: Text(movie.title!),
                );
              },
              noItemsFoundBuilder: (context) {
                return const Center(
                  child: Text("Not Found"),
                );
              },
              onSuggestionSelected: (Movie? suggestion) async {
                final movie = suggestion!;
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
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
