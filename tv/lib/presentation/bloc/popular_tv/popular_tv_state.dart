part of 'popular_tv_bloc.dart';

abstract class PopularTvState extends Equatable {
  const PopularTvState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PopularTvLoading extends PopularTvState {}

class PopularTvEmpty extends PopularTvState {}

class PopularTvError extends PopularTvState {
  final String message;

  PopularTvError(this.message);

  @override
  List<Object> get props => [message];
}


class PopularTvHasData extends PopularTvState {
  final List<Tv> result;

  PopularTvHasData(this.result);

  @override
  List<Object> get props => [result];
}
