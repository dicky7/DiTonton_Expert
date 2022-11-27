part of 'tv_on_air_bloc.dart';

abstract class TvOnAirEvent extends Equatable {
  const TvOnAirEvent();
}

class FetchTvOnAir extends TvOnAirEvent{
  @override
  List<Object?> get props => [];

}
