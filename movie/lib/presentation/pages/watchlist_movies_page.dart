import 'package:core/core.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/watchlist_movie_notifier.dart';
import 'movie_detail_page.dart';

class WatchlistMoviesPage extends StatefulWidget {
  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Future.microtask(() =>
        Provider.of<WatchlistMovieNotifier>(context, listen: false).fetchWatchlistMovies()));
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    Future.microtask(() =>
        Provider.of<WatchlistMovieNotifier>(context, listen: false)
            .fetchWatchlistMovies());
    super.didPopNext();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WatchlistMovieNotifier>(
        builder: (context, data, child) {
          if (data.watchlistState == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (data.watchlistState == RequestState.Loaded) {
            if (data.watchlistMovies.length > 0) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.watchlistMovies[index];
                  return ItemCard(
                    activeDrawerItem: DrawerItem.Movie,
                    routeName: MOVIE_DETAIL_ROUTE,
                    movie: movie,
                  );
                },
                itemCount: data.watchlistMovies.length,
              );
            }
            else {
              return const Center(child: Text("Tv Watchlist Empty"));
            }
          } else {
            return Center(
              key: Key('error_message'),
              child: Text(data.message),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
