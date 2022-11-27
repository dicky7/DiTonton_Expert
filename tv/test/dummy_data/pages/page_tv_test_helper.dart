


import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_recommendation/tv_recommendation_bloc.dart';
import 'package:tv/presentation/bloc/tv_on_air/tv_on_air_bloc.dart';
import 'package:tv/presentation/bloc/watclist_tv/watchlist_tv_bloc.dart';

/**
 * Tv On Aor
 */
class FakeTvOnAirEvent extends Fake implements TvOnAirEvent {}

class FakeTvOnAirState extends Fake implements TvOnAirState {}

class FakeTvOnAirBloc extends MockBloc<TvOnAirEvent, TvOnAirState>
    implements TvOnAirBloc {}

/**
 * Top Rated Tv
 */
class FakeTopRatedTvEvent extends Fake implements TopRatedTvEvent {}

class FakeTopRatedTvState extends Fake implements TopRatedTvState {}

class FakeTopRatedTvBloc extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

/**
 * Popular Tv
 */
class FakePopularTvEvent extends Fake implements PopularTvEvent {}

class FakePopularTvState extends Fake implements PopularTvState {}

class FakePopularTvBloc extends MockBloc<PopularTvEvent, PopularTvState>
    implements PopularTvBloc {}

/**
 * Tv Detail
 */
class FakeTvDetailEvent extends Fake implements TvDetailEvent {}

class FakeTvDetailState extends Fake implements TvDetailState {}

class FakeTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

/**
 * Tv Recommendation
 */
class FakeTvRecommendationEvent extends Fake implements TvRecommendationEvent {}

class FakeTvRecommendationState extends Fake implements TvRecommendationState {}

class FakeTvRecommendationBloc extends MockBloc<TvRecommendationEvent, TvRecommendationState>
    implements TvRecommendationBloc {}

/**
 * Watchlist Movie
 */
class FakeWatchlistTvEvent extends Fake implements WatchlistTvEvent {}

class FakeWatchlistTvState extends Fake implements WatchlistTvState {}

class FakeWatchlistTvBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}
