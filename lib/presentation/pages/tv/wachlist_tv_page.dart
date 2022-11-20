import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/drawer_item_enum.dart';
import '../../../common/state_enum.dart';
import '../../widgets/item_card_list.dart';

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
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.state == RequestState.Loaded) {
            if (data.watchlistTv.length > 0) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = data.watchlistTv[index];
                  return ItemCard(
                    activeDrawerItem: DrawerItem.TvShow,
                    routeName: TvDetailPage.ROUTE_NAME,
                    tv: tvShow,
                  );
                },
                itemCount: data.watchlistTv.length,
              );
            }
            else{
              return Center(child: Text("Tv Watchlist Empty"));
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