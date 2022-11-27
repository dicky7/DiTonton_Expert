part of 'tv_on_air_bloc.dart';

abstract class TvOnAirState extends Equatable {
  const TvOnAirState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TvOnAirEmpty extends TvOnAirState {}

class TvOnAirLoading extends TvOnAirState {}

class TvOnAirError extends TvOnAirState {
  final String message;

  TvOnAirError(this.message);

  @override
  List<Object> get props => [message];
}

class TvOnAirHasData extends TvOnAirState {
  final List<Tv> result;

  TvOnAirHasData(this.result);

  @override
  List<Object> get props => [result];
}
