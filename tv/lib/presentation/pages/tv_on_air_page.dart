
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/tv_on_air/tv_on_air_bloc.dart';

class TvOnTheAirPage extends StatefulWidget{

  @override
  State<TvOnTheAirPage> createState() => _TvOnTheAirPageState();
}

class _TvOnTheAirPageState extends State<TvOnTheAirPage> {
  @override
  void initState() {
    Future.microtask((){
      context.read<TvOnAirBloc>().add(FetchTvOnAir());
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tv On Air"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocBuilder<TvOnAirBloc, TvOnAirState>(
          builder: (context, state) {
            if (state is TvOnAirLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TvOnAirHasData) {
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
            } else if (state is TvOnAirEmpty) {
              return const Center(
                child: Text("Tv Empty", key: Key("empty")),
              );
            } else if (state is TvOnAirError) {
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
        )
      ),
    );
  }
}