
import 'package:core/presentation/bloc/searchMovie/search_bloc_movie.dart';
import 'package:core/presentation/bloc/searchMovie/search_event_movie.dart';
import 'package:core/presentation/bloc/searchMovie/search_state_movie.dart';
import 'package:core/presentation/bloc/searchTv/search_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:provider/provider.dart';
import 'package:tv/domain/entities/tv.dart';

import '../../styles/text_styles.dart';
import '../../utils/drawer_item_enum.dart';
import '../../utils/routes.dart';
import '../../utils/state_enum.dart';
import '../provider/search_notifier.dart';
import '../widgets/item_card_list.dart';


class SearchPage extends StatelessWidget {

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
              onChanged: (query) {
                if (activeDrawerItem == DrawerItem.Movie) {
                  context.read<SearchBlocMovie>().add(OnQueryChanged(query));
                } else {
                  context.read<SearchTvBloc>().add(OnQueryTvChanged(query));
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            _buildSearchResult()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResult(){
    if(activeDrawerItem == DrawerItem.Movie){
      return _buildListMovie();
    }else{
      return _buildListTv();
    }
  }

  Widget _buildListMovie() {
    return BlocBuilder<SearchBlocMovie, SearchStateMovie>(
      builder: (context, state) {
        if (state is SearchMovieLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (state is SearchMovieHasData) {
          final result = state.resultMovie;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final movie = result[index];
                return ItemCard(
                  activeDrawerItem: DrawerItem.Movie,
                  routeName: MOVIE_DETAIL_ROUTE,
                  movie: movie,
                );
              },
              itemCount: result.length,
            ),
          );
        }
        else if(state is SearchMovieEmpty){
          return Expanded(
            child: Center(
              child: Text("Movie Not Found"),
            ),
          );
        }
        else if(state is SearchMovieError){
          return Expanded(
            child: Center(
              child: Text(state.message),
            ),
          );
        }
        else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }

  Widget _buildListTv() {
    return BlocBuilder<SearchTvBloc, SearchTvState>(
      builder: (context, state) {
        if (state is SearchTvLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else if (state is SearchTvHasData) {
          final result = state.result;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tvShow = result[index];
                return ItemCard(
                  activeDrawerItem: DrawerItem.TvShow,
                  routeName: TV_DETAIL_ROUTE,
                  tv: tvShow,
                );
              },
              itemCount: result.length,
            ),
          );
        }
        else if(state is SearchTvEmpty){
          return Expanded(
            child: Center(
              child: Text("Tv Not Found"),
            ),
          );
        }
        else if(state is SearchTvError){
          return Expanded(
            child: Center(
              child: Text(state.message),
            ),
          );
        }
        else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }
}

