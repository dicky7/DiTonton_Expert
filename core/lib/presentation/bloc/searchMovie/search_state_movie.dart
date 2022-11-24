import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:tv/domain/entities/tv.dart';

abstract class SearchStateMovie extends Equatable{
  const SearchStateMovie();

  @override
  List<Object?> get props => [];
}

class SearchMovieEmpty extends SearchStateMovie{}

class SearchMovieLoading extends SearchStateMovie{}

class SearchMovieError extends SearchStateMovie{
  final String message;
  SearchMovieError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchMovieHasData extends SearchStateMovie{
  final List<Movie> resultMovie;
  SearchMovieHasData(this.resultMovie);

  @override
  List<Object?> get props => [resultMovie];
}
