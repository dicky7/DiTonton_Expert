part of 'top_rated_movie_bloc.dart';

abstract class TopRatedMovieState extends Equatable {
  const TopRatedMovieState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TopRatedMovieEmpty extends TopRatedMovieState {}

class TopRatedMovieLoading extends TopRatedMovieState {}

class TopRatedMovieError extends TopRatedMovieState {
  final String message;

  TopRatedMovieError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class TopRatedMovieHasData extends TopRatedMovieState {
  final List<Movie> result;

  TopRatedMovieHasData(this.result);

  @override
  List<Object> get props => [result];
}
