part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MovieDetailEmpty extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class MovieDetailHasData extends MovieDetailState{
  final MovieDetail resultDetail;

  MovieDetailHasData(this.resultDetail);

  @override
  List<Object> get props => [resultDetail];
}
