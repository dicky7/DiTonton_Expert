import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/bloc/watclist_tv/watchlist_tv_bloc.dart';


class WatchlistTvPage extends StatefulWidget {
  @override
  State<WatchlistTvPage> createState() => _WatchlistTvPageState();
}

class _WatchlistTvPageState extends State<WatchlistTvPage> with RouteAware {
  @override
  void initState() {
    Future.microtask(() => context.read<WatchlistTvBloc>().add(WatchlistTvList()));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  void didPopNext() {
    context.read<WatchlistTvBloc>().add(WatchlistTvList());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        key: Key("watchlist_tv_content"),
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
          builder: (context, state) {
            if (state is WatchlistTvLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WatchlistTvHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = state.result[index];
                  return ItemCard(
                    activeDrawerItem: DrawerItem.TvShow,
                    routeName: TV_DETAIL_ROUTE,
                    tv: tvShow,
                  );
                },
                itemCount: state.result.length,
              );
            } else if (state is WatchlistTvEmpty) {
              return const Center(
                child: Text("Tv Empty", key: Key("empty")),
              );
            } else if (state is WatchlistTvError) {
              return Center(
                  child: Text(
                state.message,
                key: Key("error"),
              ));
            } else {
              return const Center(
                child: Text('Failed', key: Key("failed")),
              );
            }
          },
        ));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
