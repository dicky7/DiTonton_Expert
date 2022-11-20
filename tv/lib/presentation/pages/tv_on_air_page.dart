
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class TvOnTheAirPage extends StatefulWidget{

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
        title: const Text("Tv On Air"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Consumer<TvOnAirNotifier>(
          builder: (context, data, child) {
            if (data.tvOnTheAirState == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.tvOnTheAirState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShows = data.tvOnTheAir[index];
                  return ItemCard(
                    activeDrawerItem: DrawerItem.TvShow,
                    routeName: TV_DETAIL_ROUTE,
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