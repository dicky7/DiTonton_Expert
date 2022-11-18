import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/drawer_item_enum.dart';
import 'movie_detail_page.dart';

class WatchlistMoviesPage extends StatefulWidget {

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistMovieNotifier>(context, listen: false)
            .fetchWatchlistMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WatchlistMovieNotifier>(
        builder: (context, data, child) {
          if (data.watchlistState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistState == RequestState.Loaded) {
            if (data.watchlistMovies.length > 0 ) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.watchlistMovies[index];
                  return ItemCard(
                    activeDrawerItem: DrawerItem.Movie,
                    routeName: MovieDetailPage.ROUTE_NAME,
                    movie: movie,
                  );
                },
                itemCount: data.watchlistMovies.length,
              );
            }
            else{
              return Center(child: Text("Tv Watchlist Empty"));
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
}
