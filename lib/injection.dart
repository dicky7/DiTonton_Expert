import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:ditonton/data/movie/datasources/db/database_helper.dart';
import 'package:ditonton/data/movie/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/movie/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/movie/repositories/movie_repository_impl.dart';
import 'package:ditonton/domain/movie/repositories/movie_repository.dart';
import 'package:ditonton/domain/movie/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/movie/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/movie/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/movie/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/movie/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/movie/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/movie/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/movie/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/movie/usecases/save_watchlist.dart';
import 'package:ditonton/domain/movie/usecases/search_movies.dart';
import 'package:ditonton/domain/tv/repositories/tv_repository.dart';
import 'package:ditonton/domain/tv/usecase/get_popular_tv.dart';
import 'package:ditonton/domain/tv/usecase/get_top_rated_tv.dart';
import 'package:ditonton/domain/tv/usecase/get_tv_on_the_air.dart';
import 'package:ditonton/domain/tv/usecase/get_tv_recommendations.dart';
import 'package:ditonton/domain/tv/usecase/get_watchlist_tv.dart';
import 'package:ditonton/domain/tv/usecase/remove_watchlist_tv.dart';
import 'package:ditonton/domain/tv/usecase/save_watchlist_tv.dart';
import 'package:ditonton/domain/tv/usecase/search_tv.dart';
import 'package:ditonton/presentation/provider/home_notifier.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/tv/popular_tv_notifier.dart';
import 'package:ditonton/presentation/provider/tv/top_rated_tv_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_on_air_notifier.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/tv/datasources/db/tv_database_helper.dart';
import 'data/tv/datasources/tv_local_data_source.dart';
import 'data/tv/datasources/tv_remote_data_source.dart';
import 'data/tv/repositories/tv_repository_impl.dart';
import 'domain/tv/usecase/get_tv_detail.dart';
import 'domain/tv/usecase/get_watchlist_status_tv.dart';

final locator = GetIt.instance;

void init() {
  // provider movie
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => SearchNotifier(
      searchMovies: locator(),
      searchTv: locator()
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );
  // provider tv
  locator.registerFactory(
        () => TvListNotifier(
      getTvOnTheAir: locator(),
      getPopularTv: locator(),
      getTopRatedTv: locator(),
    ),
  );
  locator.registerFactory(
        () => TvDetailNotifier(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatusTv: locator(),
      saveWatchListTv: locator(),
      removeWatchListTv: locator(),
    ),
  );
  locator.registerFactory(
        () => TvOnAirNotifier(
      getTvOnTheAir: locator(),
    ),
  );
  locator.registerFactory(
        () => PopularTvNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
        () => TopRatedTvNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
        () => WatchlistTvNotifier(
      locator(),
    ),
  );

  //provider home
  locator.registerFactory(
        () => HomeNotifier(),
  );


  // use case movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  // use case tv
  locator.registerLazySingleton(() => GetTvOnTheAir(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchListTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchListTv(locator()));
  locator.registerLazySingleton(() => GetWatchListTv(locator()));


  // repository movie
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  // repository tv
  locator.registerLazySingleton<TvRepository>(
        () => TvRepositoryImpl(
          localDataSource: locator(),
          remoteDataSource: locator()
    ),
  );


  // data sources movie
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  // data sources tv
  locator.registerLazySingleton<TvRemoteDataSource>(
          () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
          () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator.registerLazySingleton<TvDatabaseHelper>(() => TvDatabaseHelper());


  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => DataConnectionChecker());
}
