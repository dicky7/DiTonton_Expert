import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/drawer_item_enum.dart';
import '../../../common/state_enum.dart';
import '../../provider/tv/tv_on_air_notifier.dart';
import '../../widgets/item_card_list.dart';

class TvOnTheAirPage extends StatefulWidget{
  static const ROUTE_NAME = "/tv_on_air";
  @override
  State<TvOnTheAirPage> createState() => _TvOnTheAirPageState();
}

class _TvOnTheAirPageState extends State<TvOnTheAirPage> {
  @override
  void initState() {
    Future.microtask((){
      Provider.of<TvOnAirNotifier>(context, listen: false).fetchTvOnTheAir();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tv On Air"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Consumer<TvOnAirNotifier>(
          builder: (context, data, child) {
            if (data.tvOnTheAirState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.tvOnTheAirState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShows = data.tvOnTheAir[index];
                  return ItemCard(
                    activeDrawerItem: DrawerItem.TvShow,
                    routeName: TvDetailPage.ROUTE_NAME,
                    tv: tvShows,
                  );
                },
                itemCount: data.tvOnTheAir.length,
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