import 'package:core/domain/usecase/search_movies.dart';
import 'package:core/presentation/bloc/searchMovie/search_event_movie.dart';
import 'package:core/presentation/bloc/searchMovie/search_state_movie.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBlocMovie extends Bloc<SearchEventMovie, SearchStateMovie> {
  final SearchMovies _searchMovies;

  SearchBlocMovie(this._searchMovies) : super(SearchMovieEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchMovieLoading());
      final result = await _searchMovies.execute(query);

      result.fold(
        (failure) {
          emit(SearchMovieError(failure.message));
        },
        (data) {
          data.isEmpty
              ?emit(SearchMovieEmpty())
              :emit(SearchMovieHasData(data));
        });
    }, transformer: debounce(Duration(milliseconds: 500)));
  }
}