
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';

abstract class PopularMovieState extends Equatable {
  const PopularMovieState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PopularMovieEmpty extends PopularMovieState {}

class PopularMovieLoading extends PopularMovieState {}

class PopularMovieError extends PopularMovieState {
  final String message;

  PopularMovieError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}


class PopularMovieHasData extends PopularMovieState {
  final List<Movie> result;

  PopularMovieHasData(this.result);

  @override
  List<Object> get props => [result];
}
