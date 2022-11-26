import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';

abstract class NowPlayingMovieState extends Equatable {
  const NowPlayingMovieState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class NowPlayingMovieEmpty extends  NowPlayingMovieState{}

class NowPlayingMovieLoading extends NowPlayingMovieState{}

class NowPlayingMovieError extends NowPlayingMovieState{
  final String message;

  NowPlayingMovieError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message ];
}

class NowPlayingMovieHasData extends NowPlayingMovieState {
  final List<Movie> result;

  NowPlayingMovieHasData(this.result);

  @override
  List<Object> get props => [result];
}
