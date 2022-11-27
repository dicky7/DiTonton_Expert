part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvEvent extends Equatable {
  const WatchlistTvEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WatchlistTvList extends WatchlistTvEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class WatchlistTvAdd extends WatchlistTvEvent{
  final TvDetail tvDetail;

  WatchlistTvAdd(this.tvDetail);

  @override
  // TODO: implement props
  List<Object?> get props => [tvDetail];

}
class WatchlistTvRemove extends WatchlistTvEvent{
  final TvDetail tvDetail;

  WatchlistTvRemove(this.tvDetail);

  @override
  // TODO: implement props
  List<Object?> get props => [tvDetail];

}

class WatchlistTvStatus extends WatchlistTvEvent{
  final int id;

  WatchlistTvStatus(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];

}