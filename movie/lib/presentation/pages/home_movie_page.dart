import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_event.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_state.dart';
import 'package:movie/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/movie.dart';
import '../bloc/now_playing_movie/now_playing_movie_bloc.dart';
import '../bloc/now_playing_movie/now_playing_movie_state.dart';
import '../bloc/popular_movie/popular_movie_bloc.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    Future.microtask(() {
      context.read<NowPlayingMovieBloc>().add(FetchNewPlayingMovie());
      context.read<TopRatedMovieBloc>().add(FetchTopRatedMovie());
      context.read<PopularMovieBloc>().add(FetchPopularMovie());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies Nflix'),
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_ROUTE,
                  arguments: DrawerItem.Movie);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNowPlaying(),
              _buildSubHeading(
                  title: 'Popular',
                  onTap: () => Navigator.pushNamed(context, POPULAR_MOVIES_ROUTE)),
              _buildTopRated(),
              _buildSubHeading(
                  title: 'Top Rated',
                  onTap: () => Navigator.pushNamed(context, TOP_RATED_MOVIE_ROUTE)),
              _buildPopular()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNowPlaying() {
    return BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
      builder: (context, state) {
        if (state is NowPlayingMovieLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NowPlayingMovieHasData) {
          final result = state.result;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoverMovies(result[0]),
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              MovieList(result)
            ],
          );
        } else if (state is NowPlayingMovieEmpty) {
          return const Center(
            child: Text("Movie Empty", key: Key("empty")),
          );
        } else if (state is NowPlayingMovieError) {
          return Center(
            child: Text(state.message, key: Key("error")),
          );
        } else {
          return const Center(
            child: Text('Failed', key: Key("failed")),
          );
        }
      },
    );
  }

  Widget _buildTopRated() {
    return BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
      builder: (context, state) {
        if (state is TopRatedMovieLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TopRatedMovieHasData) {
          return MovieList(state.result);
        } else if (state is TopRatedMovieEmpty) {
          return const Center(
            child: Text("Movie Top Rated Empty", key: Key("empty")),
          );
        } else if (state is TopRatedMovieError) {
          return Center(
            child: Text(state.message, key: Key("error")),
          );
        } else {
          return const Center(
            child: Text('Failed', key: Key("failed")),
          );
        }
      },
    );
  }

  Widget _buildPopular() {
    return BlocBuilder<PopularMovieBloc, PopularMovieState>(
      builder: (context, state) {
        if (state is PopularMovieLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PopularMovieHasData) {
          return MovieList(state.result);
        } else if (state is PopularMovieEmpty) {
          return const Center(
            child: Text("Movie Popular Empty", key: Key("empty")),
          );
        } else if (state is PopularMovieError) {
          return Center(
            child: Text(state.message, key: Key("error")),
          );
        } else {
          return const Center(
            child: Text('Failed', key: Key("failed")),
          );
        }
      },
    );
  }

  Widget _buildCoverMovies(Movie nowPlayingMovie) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          MOVIE_DETAIL_ROUTE,
          arguments: nowPlayingMovie.id,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black,
                  Colors.black,
                  Colors.transparent,
                ],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: CachedNetworkImage(
              imageUrl: '$BASE_IMAGE_URL${nowPlayingMovie.posterPath}',
              fit: BoxFit.cover,
              height: 500,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.circle,
                color: Colors.redAccent,
                size: 18.0,
              ),
              const SizedBox(width: 8),
              Text(
                "Now Playing".toUpperCase(),
                style: kHeading6,
              )
            ],
          )
        ],
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MOVIE_DETAIL_ROUTE,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
