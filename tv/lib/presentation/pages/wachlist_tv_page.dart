
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/watchlist_tv_notifier.dart';


class WatchlistTvPage extends StatefulWidget{
  @override
  State<WatchlistTvPage> createState() => _WatchlistTvPageState();
}

class _WatchlistTvPageState extends State<WatchlistTvPage> with RouteAware {
  @override
  void initState() {
    Future.microtask(() => Provider.of<WatchlistTvNotifier>(context, listen: false).fetchWatchlistTv());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  void didPopNext() {
    Provider.of<WatchlistTvNotifier>(context, listen: false).fetchWatchlistTv();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WatchlistTvNotifier>(
        builder: (context, data, child) {
          if (data.state == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (data.state == RequestState.Loaded) {
            if (data.watchlistTv.length > 0) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = data.watchlistTv[index];
                  return ItemCard(
                    activeDrawerItem: DrawerItem.TvShow,
                    routeName: TV_DETAIL_ROUTE,
                    tv: tvShow,
                  );
                },
                itemCount: data.watchlistTv.length,
              );
            }
            else{
              return const Center(child: Text("Tv Watchlist Empty"));
            }

          } else {
            return Center(
              key: Key('error_message'),
              child: Text(data.message),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}