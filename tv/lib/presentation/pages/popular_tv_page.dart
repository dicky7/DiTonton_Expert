
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/popular_tv_notifier.dart';

class PopularTvPage extends StatefulWidget {
  @override
  State<PopularTvPage> createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    Future.microtask(() =>
    Provider.of<PopularTvNotifier>(context, listen: false)
      ..fetchPopularTv());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Tv Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularTvNotifier>(
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