import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../common/state_enum.dart';
import '../../../domain/movie/entities/genre.dart';
import '../../../domain/tv/entities/tv.dart';
import '../../../domain/tv/entities/tv_detail.dart';
import '../../../domain/tv/entities/tv_season.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = "/tv_detail";
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
      Provider.of<TvDetailNotifier>(context, listen: false)
        ..fetchTvDetail(widget.id)
        ..tvLoadedWatchListStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvDetailNotifier>(
        builder: (context, value, child) {
          if (value.tvState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (value.tvState == RequestState.Loaded) {
            final tvDetail = value.tvDetail;
            return SafeArea(
                child: TvDetailContent(
                    tvDetail,
                    value.tvRecommendations,
                    value.isAddedToWatchlist,
                )
            );
          } else {
            return Text(value.message);
          }
        },
      ),
    );
  }
}

class TvDetailContent extends StatelessWidget {
  final TvDetail tvDetail;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;

  TvDetailContent(this.tvDetail, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvDetail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              Center(
                child: CircularProgressIndicator(),
              ),
          errorWidget: (context, url, error) => Icon(Icons.error),
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
        ),
        Container(
          margin: EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: kRichBlack,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
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
                      margin: EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvDetail.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await Provider.of<TvDetailNotifier>(context, listen: false).addWatchListTv(tvDetail);
                                } else {
                                  await Provider.of<TvDetailNotifier>(context, listen: false).removeFromWatchlistTv(tvDetail);
                                }

                                final message = Provider.of<TvDetailNotifier>(context, listen: false).watchlistMessage;
                                if (message == TvDetailNotifier.tvWatchlistAddSuccessMessage ||
                                    message == TvDetailNotifier.tvWatchlistRemoveSuccessMessage) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context, builder: (context) {
                                    return AlertDialog(content: Text(message));
                                  });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text("Wacthlist")
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tvDetail.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      Icon(
                                        Icons.star,
                                        color: kMikadoYellow,
                                      ),
                                  itemSize: 24,
                                ),
                                Text('${tvDetail.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvDetail.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Consumer<TvDetailNotifier>(
                                builder: (context, value, child) {
                                  if (value.tvRecommendationState ==
                                      RequestState.Loading) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (value.tvRecommendationState ==
                                      RequestState.Loaded) {
                                    return _buildListRecommendation(
                                        recommendations);
                                  } else if (value.tvRecommendationState ==
                                      RequestState.Error) {
                                    return Center(child: Text(value.message));
                                  }
                                  else {
                                    return Container();
                                  }
                                }),
                            Text(
                              'Season Tv Show',
                              style: kHeading6,
                            ),
                            tvDetail.seasons.isNotEmpty
                                ? _buildListSeason()
                                : Text('-'),
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
        margin: EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            final season = tvDetail.seasons[index];
            return Padding(
              padding: EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                child: Stack(
                  children: [
                    season.posterPath == null
                        ? Container(
                            width: 96.0,
                            decoration: BoxDecoration(
                              color: kGrey
                            ),
                            child: Center(
                              child: Text(
                                'No Image',
                                style: TextStyle(color: kRichBlack),
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: '$BASE_IMAGE_URL${season.posterPath}',
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Icon(Icons.error),
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
                        "Season "+(index + 1).toString(),
                        style: kHeading5.copyWith(fontSize: 17.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: tvDetail.seasons.length,
        )
    );
  }

  Widget _buildListRecommendation(List<Tv> recommendations) {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final tv = recommendations[index];
          return Padding(
            padding: EdgeInsets.all(4),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                    context,
                    TvDetailPage.ROUTE_NAME,
                    arguments: tv.id
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                  placeholder: (context, url) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Icon(Icons.error);
                  },
                ),
              ),
            ),
          );
        },

      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
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