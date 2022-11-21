
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:tv/presentation/pages/wachlist_tv_page.dart';

class WatchlistPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text("Watchlist"),
            leading: Icon(Icons.menu),
            bottom: TabBar(
              tabs: [
                Tab(text: "Movie"),
                Tab(text: "Tv Show")
              ],
            )
        ),
        body: TabBarView(
          children: [
            WatchlistMoviesPage(),
            WatchlistTvPage()
          ],
        ),
      ),
    );
  }

}