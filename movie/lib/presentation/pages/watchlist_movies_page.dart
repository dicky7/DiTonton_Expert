import 'package:core/core.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      context.read<WatchlistMovieBloc>().add(WatchlistMovieList());
    });
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    Future.microtask(() {
      context.read<WatchlistMovieBloc>().add(WatchlistMovieList());
    });
    super.didPopNext();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      key: Key("watchlist_movie_content"),
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
        builder: (context, state) {
          if(state is WatchlistMovieLoading){
            return Center(child: CircularProgressIndicator());
          }else if(state is WatchlistMovieHasData){
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.result[index];
                return ItemCard(
                  activeDrawerItem: DrawerItem.Movie,
                  routeName: MOVIE_DETAIL_ROUTE,
                  movie: movie,
                );
              },
              itemCount: state.result.length,
            );
          }else if(state is WatchlistMovieEmpty){
            return const Center(
                child: Text("Movie Watchlist Empty", key: Key("movie_watchlist_empty"))
            );
          }else if (state is WatchlistMovieError) {
            return Center(
              child: Text(state.message, key: Key("error"),),
            );
          } else {
            return const Center(
              child: Text('Failed'),
            );
          }

        },
      )
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

