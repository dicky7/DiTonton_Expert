part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvState extends Equatable {
  const WatchlistTvState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WatchlistTvEmpty extends WatchlistTvState {}

class WatchlistTvLoading extends WatchlistTvState {}

class WatchlistTvError extends WatchlistTvState {
  final String message;

  WatchlistTvError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvHasData extends WatchlistTvState {
  final List<Tv> result;

  WatchlistTvHasData(this.result);

  @override
  List<Object> get props => [];
}

class TvIsAddedToWatchlist extends WatchlistTvState {
  final bool isAdded;

  TvIsAddedToWatchlist(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}

class WatchlistTvMessage extends WatchlistTvState {
  final String message;

  WatchlistTvMessage(this.message);

  @override
  List<Object> get props => [message];
}
