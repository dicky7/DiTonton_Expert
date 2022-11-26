part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WatchlistMovieEmpty extends WatchlistMovieState {}

class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieError extends WatchlistMovieState {
  final String message;

  WatchlistMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMovieMessage extends WatchlistMovieState {
  final String message;

  WatchlistMovieMessage(this.message);

  @override
  List<Object> get props => [message];
}

class MovieIsAddedToWatchlist extends WatchlistMovieState {
  final bool isAdded;

  MovieIsAddedToWatchlist(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}

class WatchlistMovieHasData extends WatchlistMovieState {
  final List<Movie> result;

  WatchlistMovieHasData(this.result);

  @override
  List<Object> get props => [result];
}

