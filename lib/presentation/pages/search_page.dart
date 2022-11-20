import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/movie/entities/movie.dart';
import 'package:ditonton/domain/tv/entities/tv.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/drawer_item_enum.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  final DrawerItem activeDrawerItem;

  SearchPage({required this.activeDrawerItem});

  @override
  Widget build(BuildContext context) {
    var _title = activeDrawerItem == DrawerItem.Movie ? "Movie" : "TV Show";

    return Scaffold(
      appBar: AppBar(
        title: Text('Search $_title\s'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                if (activeDrawerItem == DrawerItem.Movie) {
                  Provider.of<SearchNotifier>(context, listen: false)
                      .fetchMovieSearch(query);
                } else {
                  Provider.of<SearchNotifier>(context, listen: false)
                      .fetchTvSearch(query);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            Consumer<SearchNotifier>(
              builder: (context, data, child) {
                if (data.state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data.state == RequestState.Loaded) {
                  if (activeDrawerItem == DrawerItem.Movie) {
                    return _buildListMovie(data.movieSearchResult);
                  } else{
                    return _buildListTv(data.tvSearchResult);
                  }
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListMovie(List<Movie> movieSearchResult) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final movie = movieSearchResult[index];
          return ItemCard(
            activeDrawerItem: DrawerItem.Movie,
            routeName: MovieDetailPage.ROUTE_NAME,
            movie: movie,
          );
        },
        itemCount: movieSearchResult.length,
      ),
    );
  }

  Widget _buildListTv(List<Tv> tvSearchResult) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final tvShow = tvSearchResult[index];
          return ItemCard(
            activeDrawerItem: DrawerItem.TvShow,
            routeName: TvDetailPage.ROUTE_NAME,
            tv: tvShow,
          );
        },
        itemCount: tvSearchResult.length,
      ),
    );
  }
}

