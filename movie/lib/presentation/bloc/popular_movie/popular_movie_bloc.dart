import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_event.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_state.dart';

import '../../../domain/usecases/get_popular_movies.dart';


class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies _getPopularMovies;

  PopularMovieBloc(this._getPopularMovies) : super(PopularMovieEmpty()) {
    on<FetchPopularMovie>((event, emit) async {
      emit(PopularMovieLoading());
      final result = await _getPopularMovies.execute();

      result.fold(
        (failure) => emit(PopularMovieError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(PopularMovieEmpty());
          } else {
            emit(PopularMovieHasData(data));
          }
        });
    });
  }
}
