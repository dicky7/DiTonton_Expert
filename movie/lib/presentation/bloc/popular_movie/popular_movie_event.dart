
import 'package:equatable/equatable.dart';

abstract class PopularMovieEvent extends Equatable {
  const PopularMovieEvent();
}

class FetchPopularMovie extends PopularMovieEvent{
  @override
  List<Object?> get props => [];

}
