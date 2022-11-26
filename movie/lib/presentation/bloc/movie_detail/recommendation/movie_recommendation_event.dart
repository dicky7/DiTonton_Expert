part of 'movie_recommendation_bloc.dart';

abstract class MovieRecommendationEvent extends Equatable {
  const MovieRecommendationEvent();
}

class FetchMovieRecommendation extends MovieRecommendationEvent{
  final int id;

  FetchMovieRecommendation(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];

}
