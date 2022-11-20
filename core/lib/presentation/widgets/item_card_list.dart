
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:tv/domain/entities/tv.dart';
import '../../styles/text_styles.dart';
import '../../utils/constants.dart';
import '../../utils/drawer_item_enum.dart';

class ItemCard extends StatelessWidget {
  final Movie? movie;
  final Tv? tv;
  final DrawerItem activeDrawerItem;
  final String routeName;


  ItemCard({this.movie, this.tv, required this.activeDrawerItem, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            routeName,
            arguments: _getId(),
          );
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitle() ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getOverview() ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${_getPosterPath()}',
                  width: 80,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getId() => activeDrawerItem == DrawerItem.Movie
      ? movie?.id as int
      : tv?.id as int;

  String? _getTitle() => activeDrawerItem == DrawerItem.Movie
      ? movie?.title
      : tv?.name;

  String? _getOverview() => activeDrawerItem == DrawerItem.Movie
      ? movie?.overview
      : tv?.overview;

  String _getPosterPath() => activeDrawerItem == DrawerItem.Movie
      ? movie?.posterPath as String
      : tv?.posterPath as String;
}
