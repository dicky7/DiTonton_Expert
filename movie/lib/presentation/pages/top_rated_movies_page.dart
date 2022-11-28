import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedMoviesPage extends StatefulWidget {
  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
     context.read<TopRatedMovieBloc>().add(FetchTopRatedMovie());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('top_rated_content'),
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
          builder: (context, state) {
            if (state is TopRatedMovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopRatedMovieHasData) {
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
            } else if (state is TopRatedMovieEmpty) {
              return const Center(
                child: Text("Movie Top Rated Empty"),
              );
            } else if (state is TopRatedMovieError) {
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
