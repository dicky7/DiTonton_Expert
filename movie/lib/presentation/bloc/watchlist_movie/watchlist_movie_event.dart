part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WatchlistMovieAdd extends WatchlistMovieEvent{
  final MovieDetail detail;

  WatchlistMovieAdd(this.detail);

  @override
  // TODO: implement props
  List<Object?> get props => [detail];
}

class WatchlistMovieRemove extends WatchlistMovieEvent{
  final MovieDetail detail;

  WatchlistMovieRemove(this.detail);

  @override
  // TODO: implement props
  List<Object?> get props => [detail];
}

class WatchlistMovieStatus extends WatchlistMovieEvent{
  final int id;

  WatchlistMovieStatus(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class WatchlistMovieList extends WatchlistMovieEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
