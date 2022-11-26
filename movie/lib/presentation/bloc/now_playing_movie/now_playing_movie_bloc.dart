import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_now_playing_movies.dart';
import 'now_playing_movie_state.dart';

part 'now_playing_movie_event.dart';

class NowPlayingMovieBloc extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMovieBloc(this._getNowPlayingMovies) : super(NowPlayingMovieEmpty()) {
    on<FetchNewPlayingMovie>((event, emit) async {
      emit(NowPlayingMovieLoading());
      final result = await _getNowPlayingMovies.execute();

      result.fold(
        (failure) => emit(NowPlayingMovieError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(NowPlayingMovieEmpty());
          } else {
            emit(NowPlayingMovieHasData(data));
          }
        });
    });
  }
}
