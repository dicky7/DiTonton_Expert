
import 'package:core/core.dart';
import 'package:core/utils/drawer_item_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/top_rated_tv/top_rated_tv_bloc.dart';

class TopRatedTvPage extends StatefulWidget{
  @override
  State<TopRatedTvPage> createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    Future.microtask(() =>
    context.read<TopRatedTvBloc>().add(FetchTopRatedTv()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
          builder: (context, state) {
            if (state is TopRatedTvLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopRatedTvHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShows = state.result[index];
                  return ItemCard(
                    activeDrawerItem: DrawerItem.TvShow,
                    routeName: TV_DETAIL_ROUTE,
                    tv: tvShows,
                  );
                },
                itemCount: state.result.length,
              );
            } else if (state is TopRatedTvEmpty) {
              return const Center(
                child: Text("Tv Empty", key: Key("empty")),
              );
            } else if (state is TopRatedTvError) {
              return Center(child: Text(state.message, key: Key("error")));
            } else {
              return const Center(
                child: Text('Failed', key: Key("failed")),
              );
            }
          },
        )
      ),
    );
  }
}