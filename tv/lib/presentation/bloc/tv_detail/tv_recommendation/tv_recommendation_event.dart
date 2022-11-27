part of 'tv_recommendation_bloc.dart';

abstract class TvRecommendationEvent extends Equatable {
  const TvRecommendationEvent();
}

class FetchTvRecommendation extends TvRecommendationEvent{
  final int id;

  FetchTvRecommendation(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];

}
