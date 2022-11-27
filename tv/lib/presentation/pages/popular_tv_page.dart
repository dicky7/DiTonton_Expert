
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';


class PopularTvPage extends StatefulWidget {
  @override
  State<PopularTvPage> createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    Future.microtask(() =>
    context.read<PopularTvBloc>().add(FetchPopularTv()));
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
        child: BlocBuilder<PopularTvBloc, PopularTvState>(
          builder: (context, state) {
            if (state is PopularTvLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PopularTvHasData) {
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
            } else if (state is PopularTvEmpty) {
              return const Center(
                child: Text("Tv Empty", key: Key("empty")),
              );
            } else if (state is PopularTvError) {
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