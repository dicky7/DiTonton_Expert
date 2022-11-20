import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:core/presentation/pages/search_page.dart';
import 'package:ditonton/injection.dart' as di;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/pages/popular_tv_page.dart';
import 'package:tv/presentation/pages/top_rated_tv_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/pages/tv_on_air_page.dart';
void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //movie
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<SearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),

        /**
         * Tv Show
         */
        ChangeNotifierProvider(
          create: (_) => di.locator<TvListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvOnAirNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTvNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvNotifier>(),
        ),
        //home page
        ChangeNotifierProvider(
          create: (_) => di.locator<HomeNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: Material(
          child: HomePage(),
        ),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case POPULAR_MOVIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TOP_RATED_MOVIE_ROUTE:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MOVIE_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SEARCH_ROUTE:
              final activeDrawerItem = settings.arguments as DrawerItem;
              return CupertinoPageRoute(builder: (_) => SearchPage(
                activeDrawerItem: activeDrawerItem,
              ));
            case ABOUT_ROUTE:
              return MaterialPageRoute(builder: (_) => AboutPage());

            // Tv Route
            case TV_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings
              );
            case TV_ON_AIR_ROUTE:
              return MaterialPageRoute(builder: (_) => TvOnTheAirPage());
            case POPULAR_MOVIES_ROUTE:
              return MaterialPageRoute(builder: (_) => PopularTvPage());
            case TOP_RATED_TV_ROUTE:
              return MaterialPageRoute(builder: (_) => TopRatedTvPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
