
import 'package:core/presentation/bloc/searchMovie/search_bloc_movie.dart';
import 'package:core/presentation/bloc/searchMovie/search_event_movie.dart';
import 'package:core/presentation/bloc/searchMovie/search_state_movie.dart';
import 'package:core/presentation/bloc/searchTv/search_tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../styles/text_styles.dart';
import '../../utils/drawer_item_enum.dart';
import '../../utils/routes.dart';
import '../widgets/item_card_list.dart';


class SearchPage extends StatelessWidget {
  final List<String> _myTabs = ["Movie", "Tv Show"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (query) {
                    context.read<SearchBlocMovie>().add(OnQueryChanged(query));
                    context.read<SearchTvBloc>().add(OnQueryTvChanged(query));
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
                style: kHeading5,
              ),
              const SizedBox(height: 10),
              TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue.shade900
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_myTabs[0], style:kSubtitle,),
                        SizedBox(width: 10),
                        Icon(Icons.movie),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_myTabs[1], style:kSubtitle,),
                        SizedBox(width: 10),
                        Icon(Icons.tv),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Flexible(
                flex: 1,
                child: TabBarView(
                  children: [
                    _buildListMovie(),
                    _buildListTv()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildListMovie() {
    return BlocBuilder<SearchBlocMovie, SearchStateMovie>(
      builder: (context, state) {
        if (state is SearchMovieLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (state is SearchMovieHasData) {
          final result = state.resultMovie;
          return ListView.builder(
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
          );
        }
        else if(state is SearchMovieEmpty){
          return Center(
            child: Text("Movie Not Found"),
          );
        }
        else if(state is SearchMovieError){
          return Center(
            child: Text(state.message),
          );
        }
        else {
          return Container();
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
          return ListView.builder(
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
          );
        }
        else if(state is SearchTvEmpty){
          return Center(
            child: Text("Tv Not Found"),
          );
        }
        else if(state is SearchTvError){
          return Center(
            child: Text(state.message),
          );
        }
        else {
          return Container();
        }
      },
    );
  }
}



