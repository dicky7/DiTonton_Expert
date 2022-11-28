import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';

import '../../../domain/entities/movie.dart';

part 'top_rated_movie_event.dart';
part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovie;

  TopRatedMovieBloc(this._getTopRatedMovie) : super(TopRatedMovieEmpty()) {
    on<FetchTopRatedMovie>((event, emit) async {
      emit(TopRatedMovieLoading());
      final result = await _getTopRatedMovie.execute();

      result.fold(
        (failure) => emit(TopRatedMovieError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(TopRatedMovieEmpty());
          } else {
            emit(TopRatedMovieHasData(data));
          }
        });
    });
  }
}
