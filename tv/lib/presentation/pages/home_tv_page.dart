import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';

import '../../domain/entities/tv.dart';
import '../bloc/top_rated_tv/top_rated_tv_bloc.dart';
import '../bloc/tv_on_air/tv_on_air_bloc.dart';

class HomeTvPage extends StatefulWidget {
  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    Future.microtask(() {
      context.read<TvOnAirBloc>().add(FetchTvOnAir());
      context.read<PopularTvBloc>().add(FetchPopularTv());
      context.read<TopRatedTvBloc>().add(FetchTopRatedTv());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tv Show Nflix"),
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_ROUTE,
                  arguments: DrawerItem.TvShow);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTvOnAir(),
              _buildSubHeading(
                  title: "Popular",
                  onTap: () {
                    Navigator.pushNamed(context, POPULAR_TV_ROUTE);
                  }),
              _buildPopularTv(),
              _buildSubHeading(
                  title: "Top Rated",
                  onTap: () {
                    Navigator.pushNamed(context, TOP_RATED_TV_ROUTE);
                  }),
              _buildTopRatedTv(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRatedTv() {
    return BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
      builder: (context, state) {
        if (state is TopRatedTvLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TopRatedTvHasData) {
          return _buildTvList(state.result);
        } else if (state is TopRatedTvEmpty) {
          return const Center(
            child: Text("Tv Empty", key: Key("empty")),
          );
        } else if (state is TopRatedTvError) {
          return Center(child: Text(state.message, key: Key("error")));
        } else {
          return const Center(
            child: Text('Failed', key: Key("failed")),
          );
        }
      },
    );
  }

  Widget _buildPopularTv() {
    return BlocBuilder<PopularTvBloc, PopularTvState>(
      builder: (context, state) {
        if (state is PopularTvLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PopularTvHasData) {
          return _buildTvList(state.result);
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
    );
  }

  Widget _buildTvOnAir() {
    return BlocBuilder<TvOnAirBloc, TvOnAirState>(
      builder: (context, state) {
        if (state is TvOnAirLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TvOnAirHasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoverTv(state.result[0]),
              _buildSubHeading(
                  title: "Now On Air",
                  onTap: () {
                    Navigator.pushNamed(context, TV_ON_AIR_ROUTE);
                  }),
              _buildTvList(state.result),
            ],
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
    );
  }

  Widget _buildCoverTv(Tv tvShow) {
    return GestureDetector(
      key: Key("tv_cover"),
      onTap: () {
        Navigator.pushNamed(context, TV_DETAIL_ROUTE, arguments: tvShow.id);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
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
              const Icon(
                Icons.circle,
                color: Colors.redAccent,
                size: 18.0,
              ),
              const SizedBox(width: 8),
              Text(
                "Tv On The Air".toUpperCase(),
                style: kHeading6,
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
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTvList(List<Tv> tvShow) {
    return Container(
      key: Key("list_tv"),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvShow[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, TV_DETAIL_ROUTE, arguments: tv.id);
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
