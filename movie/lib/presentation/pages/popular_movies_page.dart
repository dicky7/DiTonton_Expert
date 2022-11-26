
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_state.dart';
import 'package:provider/provider.dart';

import '../bloc/popular_movie/popular_movie_bloc.dart';
import '../bloc/popular_movie/popular_movie_event.dart';



class PopularMoviesPage extends StatefulWidget {
  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PopularMovieBloc>().add(FetchPopularMovie());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('popular_movies_content'),
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieBloc, PopularMovieState>(
          builder: (context, state) {
            if (state is PopularMovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PopularMovieHasData) {
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
            } else if (state is PopularMovieEmpty) {
              return const Center(
                child: Text("Movie Popular Empty"),
              );
            } else if (state is PopularMovieError) {
              return Center(
                child: Text(state.message, key: Key("error")),
              );
            } else {
              return const Center(
                child: Text('Failed'),
              );
            }
          },
        )
      ),
    );
  }

}


