part of 'tv_detail_bloc.dart';

abstract class TvDetailState extends Equatable {
  const TvDetailState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TvDetailLoading extends TvDetailState {}

class TvDetailEmpty extends TvDetailState {}

class TvDetailError extends TvDetailState {
  final String message;

  TvDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvDetailHasData extends TvDetailState {
  final TvDetail tvDetail;

  TvDetailHasData(this.tvDetail);

  @override
  List<Object> get props => [tvDetail];
}
