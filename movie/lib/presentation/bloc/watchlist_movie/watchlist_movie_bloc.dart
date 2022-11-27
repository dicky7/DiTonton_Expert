import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_watchlist_status.dart';
import '../../../domain/usecases/remove_watchlist.dart';
import '../../../domain/usecases/save_watchlist.dart';

part 'watchlist_movie_event.dart';

part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListStatus _getWatchListStatus;
  final RemoveWatchlist _removeWatchlist;
  final SaveWatchlist _saveWatchlist;

  WatchlistMovieBloc(
    this._getWatchlistMovies,
    this._getWatchListStatus,
    this._removeWatchlist,
    this._saveWatchlist,
  ) : super(WatchlistMovieEmpty()) {

    on<WatchlistMovieList>((event, emit) async {
      emit(WatchlistMovieLoading());
      final result = await _getWatchlistMovies.execute();

      result.fold((failure) => emit(WatchlistMovieError(failure.message)),
          (data) {
        if (data.isEmpty) {
          emit(WatchlistMovieEmpty());
        } else {
          emit(WatchlistMovieHasData(data));
        }
      });
    });

    on<WatchlistMovieAdd>((event, emit) async {
      final movieDetail = event.detail;

      final result = await _saveWatchlist.execute(movieDetail);

      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (successMessage) => emit(WatchlistMovieMessage(successMessage)),
      );
    });

    on<WatchlistMovieRemove>((event, emit) async {
      final movieDetail = event.detail;

      final result = await _removeWatchlist.execute(movieDetail);

      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (successMessage) => emit(WatchlistMovieMessage(successMessage)),
      );
    });

    on<WatchlistMovieStatus>((event, emit) async {
      final id = event.id;

      final result = await _getWatchListStatus.execute(id);
      emit(MovieIsAddedToWatchlist(result));
    });
  }
}
