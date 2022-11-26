
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';


import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../bloc/movie_detail/movie_detail_bloc.dart';
import '../bloc/movie_detail/recommendation/movie_recommendation_bloc.dart';
import '../bloc/watchlist_movie/watchlist_movie_bloc.dart';


class MovieDetailPage extends StatefulWidget {
  final int id;

  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id));
      context.read<MovieRecommendationBloc>().add(FetchMovieRecommendation(widget.id));
      context.read<WatchlistMovieBloc>().add(WatchlistMovieStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    //check status movie
    final isAddedMovie = context.select<WatchlistMovieBloc, bool>((bloc){
      if (bloc.state is MovieIsAddedToWatchlist) {
        return (bloc.state as MovieIsAddedToWatchlist).isAdded;
      }
      return false;
    });

    return Scaffold(
      key: Key("content_movie_detail"),
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieDetailHasData) {
            return SafeArea(
              child: DetailContent(
                state.resultDetail,
                isAddedMovie,
              ),
            );
          } else if (state is MovieDetailError) {
            return Center(
              child: Text(state.message),
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
}

class DetailContent extends StatefulWidget {
  final MovieDetail movie;
  late bool isAddedWatchlist;

  DetailContent(this.movie, this.isAddedWatchlist);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie.title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (!widget.isAddedWatchlist) {
                                  context.read<WatchlistMovieBloc>().add(WatchlistMovieAdd(widget.movie));
                                } else {
                                  context.read<WatchlistMovieBloc>().add(WatchlistMovieRemove(widget.movie));
                                }

                                final state = BlocProvider.of<WatchlistMovieBloc>(context).state;
                                String message = "";

                                if (state is MovieIsAddedToWatchlist) {
                                  final isAdded = state.isAdded;
                                  message = isAdded == false
                                      ? watchlistAddSuccessMessage
                                      : watchlistRemoveSuccessMessage;
                                } else {
                                  message = !widget.isAddedWatchlist
                                      ? watchlistAddSuccessMessage
                                      : watchlistRemoveSuccessMessage;
                                }


                                if (message == watchlistAddSuccessMessage ||
                                    message == watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                                setState(() {
                                 widget.isAddedWatchlist = !widget.isAddedWatchlist;
                                });

                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(widget.movie.genres),
                            ),
                            Text(
                              _showDuration(widget.movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            _buildMovieRecommendations()
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMovieRecommendations() {
    return BlocBuilder<MovieRecommendationBloc, MovieRecommendationState>(
      builder: (context, state) {
        if (state is MovieRecommendationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MovieRecommendationHasData) {
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final movie = state.result[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        MOVIE_DETAIL_ROUTE,
                        arguments: movie.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        placeholder: (context, url){
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
              itemCount: state.result.length,
            ),
          );
        } else if (state is MovieRecommendationError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(
            child: Text('Failed'),
          );
        }
      },
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
