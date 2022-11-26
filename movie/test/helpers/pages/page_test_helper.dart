import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/recommendation/movie_recommendation_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movie/now_playing_movie_state.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_event.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_state.dart';
import 'package:movie/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';

/**
 * Now Playing Movie Bloc
 */
class FakeNowPlayingMovieEvent extends Fake implements NowPlayingMovieEvent {}

class FakeNowPlayingMovieState extends Fake implements NowPlayingMovieState {}

class FakeNowPlayingMovieBloc extends MockBloc<NowPlayingMovieEvent, NowPlayingMovieState>
    implements NowPlayingMovieBloc {}

/**
 * Top Rated Movie
 */
class FakeTopRatedMovieEvent extends Fake implements TopRatedMovieEvent {}

class FakeTopRatedMovieState extends Fake implements TopRatedMovieState {}

class FakeTopRatedMovieBloc extends MockBloc<TopRatedMovieEvent, TopRatedMovieState>
    implements TopRatedMovieBloc {}

/**
 * Popular Movie
 */
class FakePopularMovieEvent extends Fake implements PopularMovieEvent {}

class FakePopularMovieState extends Fake implements PopularMovieState {}

class FakePopularMovieBloc extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

/**
 * Movie Detail
 */
class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

class FakeMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

/**
 * Movie Detail
 */
class FakeMovieRecommendationEvent extends Fake implements MovieRecommendationEvent {}

class FakeMovieRecommendationState extends Fake implements MovieRecommendationState {}

class FakeMovieRecommendationBloc extends MockBloc<MovieRecommendationEvent, MovieRecommendationState>
    implements MovieRecommendationBloc {}

/**
 * Watchlist Movie
 */
class FakeWatchlistMovieEvent extends Fake implements WatchlistMovieEvent {}

class FakeWatchlistMovieState extends Fake implements WatchlistMovieState {}

class FakeWatchlistMovieBloc extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}
