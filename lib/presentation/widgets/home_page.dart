
import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/drawer_item_enum.dart';
import '../pages/home_movie_page.dart';
import '../pages/tv/home_tv_page.dart';
import '../pages/watchlist_page.dart';
import '../provider/home_notifier.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 250)
    );
  }

  Widget _buildBody(BuildContext context, DrawerItem seletedDrawerItem) {
    if (seletedDrawerItem == DrawerItem.Movie) {
      return HomeMoviePage();
    } else if (seletedDrawerItem == DrawerItem.TvShow) {
      return HomeTvPage();
    }
    else if(seletedDrawerItem ==  DrawerItem.Watchlist){
      return WatchlistPage();
    }
    return Container();
  }

  Widget _buildDrawer(Function(DrawerItem) itemCallback, DrawerItem activeDrawerItem,) {
    return Container(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://ik.imagekit.io/lkvkafaowca/netflix-logo-png-2616_FC6yOaZwX.png?ik-sdk-version=javascript-1.4.3&updatedAt=1668394551577"
              ),
            ),
            accountName: Text("NFlix"),
            accountEmail: Text("Nflix@gmail.com"),
          ),
          ListTile(
            leading: Icon(Icons.movie),
            title: Text("Movies"),
            onTap: () {
              itemCallback(DrawerItem.Movie);
              _animationController.reverse();
            },
          ),
          ListTile(
            leading: Icon(Icons.tv),
            title: Text("Tv Show"),
            onTap: () {
              itemCallback(DrawerItem.TvShow);
              _animationController.reverse();
            },
          ),
          ListTile(
            leading: Icon(Icons.save_alt),
            title: Text("Watchlist"),
            onTap: () {
              itemCallback(DrawerItem.Watchlist);
              _animationController.reverse();
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            onTap: () {
              Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              _animationController.reverse();
            },
          ),
        ],
      ),
    );
  }

  //action when drawer clicked
  void toggle() => _animationController.isDismissed
      ? _animationController.forward()
      : _animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifier>(builder: (context, value, child) {
      final activeDrawerItem = value.selectedDrawerItem;
      return GestureDetector(
        onTap: toggle,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            double slide = 255.0 * _animationController.value;
            double scale = 1 - (_animationController.value * 0.3);
            return Stack(
              children: [
                _buildDrawer((DrawerItem newselecedItem){
                  value.setSelectedDrawerItem(newselecedItem);
                }, activeDrawerItem),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slide)
                    ..scale(scale),
                  alignment: Alignment.centerLeft,
                  child: _buildBody(context, activeDrawerItem),
                )
              ],
            );
          },
        ),
      );
    });
  }
}