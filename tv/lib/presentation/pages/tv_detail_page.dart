import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/bloc/watclist_tv/watchlist_tv_bloc.dart';

import '../../domain/entities/tv_detail.dart';
import '../bloc/tv_detail/tv_detail_bloc.dart';
import '../bloc/tv_detail/tv_recommendation/tv_recommendation_bloc.dart';


class TvDetailPage extends StatefulWidget {
  final int id;

  TvDetailPage({required this.id});

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(FetchTvDetail(widget.id));
      context.read<TvRecommendationBloc>().add(FetchTvRecommendation(widget.id));
      context.read<WatchlistTvBloc>().add(WatchlistTvStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    //check status movie
    final isAddedTv = context.select<WatchlistTvBloc, bool>((bloc){
      if (bloc.state is TvIsAddedToWatchlist) {
        return (bloc.state as TvIsAddedToWatchlist).isAdded;
      }
      return false;
    });

    return Scaffold(
        key: Key("content_tv_detail"),
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TvDetailHasData) {
            return SafeArea(
                child: TvDetailContent(
                  state.tvDetail,
                  isAddedTv,
                )
            );
          } else if (state is TvDetailError) {
            return Center(child: Text(state.message, key: Key("error")));
          } else {
            return const Center(
              child: Text('Failed', key: Key("failed")),
            );
          }
        },
      )
    );
  }
}

class TvDetailContent extends StatefulWidget {
  final TvDetail tvDetail;
  late bool isAddedWatchlist;

  TvDetailContent(this.tvDetail, this.isAddedWatchlist);

  @override
  State<TvDetailContent> createState() => _TvDetailContentState();
}

class _TvDetailContentState extends State<TvDetailContent> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${widget.tvDetail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                    color: kRichBlack,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tvDetail.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (!widget.isAddedWatchlist) {
                                  context.read<WatchlistTvBloc>().add(WatchlistTvAdd(widget.tvDetail));
                                } else {
                                  context.read<WatchlistTvBloc>().add(WatchlistTvRemove(widget.tvDetail));
                                }

                                final state = BlocProvider.of<WatchlistTvBloc>(context).state;
                                String message = "";

                                if (state is TvIsAddedToWatchlist) {
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
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text("Watchlist")
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(widget.tvDetail.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.tvDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      const Icon(
                                        Icons.star,
                                        color: kMikadoYellow,
                                      ),
                                  itemSize: 24,
                                ),
                                Text('${widget.tvDetail.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Overview",
                              style: kHeading6,
                            ),
                            Text(
                              widget.tvDetail.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            _buildListRecommendation(),
                            SizedBox(height: 16),
                            Text(
                              'Season Tv Show',
                              style: kHeading6,
                            ),
                            widget.tvDetail.seasons.isNotEmpty
                                ? _buildListSeason()
                                : const Text('-'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },

          ),
        )
      ],
    );
  }

  Container _buildListSeason() {
    return Container(
        height: 150,
        margin: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            final season = widget.tvDetail.seasons[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                child: Stack(
                  children: [
                    season.posterPath == null
                        ? Container(
                            width: 96.0,
                            decoration: const BoxDecoration(
                              color: kGrey
                            ),
                            child: const Center(
                              child: Text(
                                'No Image',
                                style: TextStyle(color: kRichBlack),
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: '$BASE_IMAGE_URL${season.posterPath}',
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                    Positioned.fill(
                      child: Container(
                        color: kRichBlack.withOpacity(0.65),
                      ),
                    ),
                    Positioned(
                      left: 4.0,
                      top: 4.0,
                      child: Text(
                        "Season ${index + 1}",
                        style: kHeading5.copyWith(fontSize: 17.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: widget.tvDetail.seasons.length,
        )
    );
  }

  Widget _buildListRecommendation() {
    return BlocBuilder<TvRecommendationBloc, TvRecommendationState>(
      builder: (context, state) {
        if (state is TvRecommendationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if(state is TvRecommendationHasData){
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.result.length,
              itemBuilder: (context, index) {
                final tv = state.result[index];
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context,
                          TV_DETAIL_ROUTE,
                          arguments: tv.id
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                        placeholder: (context, url) {
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorWidget: (context, url, error) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if(state is TvRecommendationError){
          return Center(child: Text(state.message, key: Key("error")));
        }else{
          return const Center(child: Text('Failed'), key: Key("failed"),);
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