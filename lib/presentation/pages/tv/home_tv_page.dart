import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/domain/tv/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_on_air_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../../../common/constants.dart';
import '../../../common/drawer_item_enum.dart';
import '../../../common/state_enum.dart';
import '../search_page.dart';

class HomeTvPage extends StatefulWidget {
  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
          ..repeat();
    Future.microtask(() => Provider.of<TvListNotifier>(context, listen: false)
      ..fetchTopRatedTv()
      ..fetchTvPopular()
      ..fetchTvOnTheAir());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tv Show Nflix"),
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME, arguments: DrawerItem.TvShow);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<TvListNotifier>(builder: (context, value, child) {
                final state = value.tvOnTheAirState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCoverTv(value.tvOnTheAir[0]),
                      _buildSubHeading(title: "Now On Air", onTap: () {
                        Navigator.pushNamed(context, TvOnTheAirPage.ROUTE_NAME);
                      }),
                      _buildTvList(value.tvOnTheAir),
                    ],
                  );
                } else {
                  return Center(child: Text(value.message));
                }
              }),
              _buildSubHeading(title: "Popular", onTap: () {
                Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME);
              }),

              Consumer<TvListNotifier>(builder: (context, value, child) {
                final state = value.popularTvState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return _buildTvList(value.popularTv);
                } else {
                  return Center(child: Text(value.message));
                }
              }),
              _buildSubHeading(title: "Top Rated", onTap: () {
                Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME);

              }),
              Consumer<TvListNotifier>(builder: (context, value, child) {
                final state = value.topRatedTvState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return _buildTvList(value.topRatedTv);
                } else {
                  return Center(child: Text(value.message));
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverTv(Tv tvShow) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
            context,
            TvDetailPage.ROUTE_NAME,
            arguments: tvShow.id
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent
                  ]).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: CachedNetworkImage(
              imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
              height: 500,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RippleAnimation(
                repeat: true,
                color: Colors.red,
                minRadius: 15,
                ripplesCount: 3,
                child: Icon(
                  Icons.circle,
                  color: Colors.redAccent,
                  size: 16,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "Tv On The Air".toUpperCase(),
                style: TextStyle(fontSize: 16.0),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTvList(List<Tv> tvShow) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvShow[index];
          return Container(
            padding: EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShow.length,
      ),
    );
  }
}
