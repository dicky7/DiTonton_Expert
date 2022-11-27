part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();
}

class FetchTvDetail extends TvDetailEvent{
  final int id;

  FetchTvDetail(this.id);

  @override
  List<Object?> get props => [id];

}
