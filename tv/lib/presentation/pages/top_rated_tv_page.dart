
import 'package:core/core.dart';
import 'package:core/utils/drawer_item_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/top_rated_tv_notifier.dart';

class TopRatedTvPage extends StatefulWidget{
  @override
  State<TopRatedTvPage> createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    Future.microtask(() =>
    Provider.of<TopRatedTvNotifier>(context, listen: false)
      ..fetchTopRatedTv());
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
        child: Consumer<TopRatedTvNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShows = data.tvShow[index];
                  return ItemCard(
                    activeDrawerItem: DrawerItem.TvShow,
                    routeName: TV_DETAIL_ROUTE,
                    tv: tvShows,
                  );
                },
                itemCount: data.tvShow.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}