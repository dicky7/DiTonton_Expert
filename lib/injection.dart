
import 'package:core/domain/usecase/search_movies.dart';
import 'package:core/domain/usecase/search_tv.dart';
import 'package:core/presentation/bloc/searchMovie/search_bloc_movie.dart';
import 'package:core/presentation/bloc/searchTv/search_tv_bloc.dart';
import 'package:core/presentation/provider/home_notifier.dart';
import 'package:core/presentation/provider/search_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movie/data/datasources/db/database_helper.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/data/repositories/movie_repository_impl.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/recommendation/movie_recommendation_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:tv/data/datasources/db/tv_database_helper.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecase/get_popular_tv.dart';
import 'package:tv/domain/usecase/get_top_rated_tv.dart';
import 'package:tv/domain/usecase/get_tv_detail.dart';
import 'package:tv/domain/usecase/get_tv_on_the_air.dart';
import 'package:tv/domain/usecase/get_tv_recommendations.dart';
import 'package:tv/domain/usecase/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecase/get_watchlist_tv.dart';
import 'package:tv/domain/usecase/remove_watchlist_tv.dart';
import 'package:tv/domain/usecase/save_watchlist_tv.dart';
import 'package:tv/presentation/provider/popular_tv_notifier.dart';
import 'package:tv/presentation/provider/top_rated_tv_notifier.dart';
import 'package:tv/presentation/provider/tv_detail_notifier.dart';
import 'package:tv/presentation/provider/tv_list_notifier.dart';
import 'package:tv/presentation/provider/tv_on_air_notifier.dart';
import 'package:tv/presentation/provider/watchlist_tv_notifier.dart';


final locator = GetIt.instance;

void init() {
  // bloc movie
  locator.registerFactory(
    () =>NowPlayingMovieBloc(
      locator()
    ),
  );
  locator.registerFactory(
        () =>TopRatedMovieBloc(
        locator()
    ),
  );
  locator.registerFactory(
        () =>PopularMovieBloc(
        locator()
    ),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
      locator()
    ),
  );
  locator.registerFactory(
        () => MovieRecommendationBloc(
        locator()
    ),
  );
  locator.registerFactory(
        () => WatchlistMovieBloc(
        locator(),
        locator(),
        locator(),
        locator(),
    ),
  );
  locator.registerFactory(
    () => SearchBlocMovie(
       locator()
    )
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
    () => SearchTvBloc(
      locator()
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
}
