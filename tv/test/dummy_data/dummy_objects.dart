
import 'package:core/domain/entities/genre.dart';
import 'package:tv/data/model/tv_table.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/entities/tv_season.dart';

/**
 * TV DUMMY OBJECT
 */
final testTv = Tv(
    backdropPath: "/A7pq4B0uCPCLvk1EPFKQgJZQoVG.jpg",
    firstAirDate: "2022-08-25",
    genreIds:  [
      16,
      35
    ],
    id: 125392,
    name: "Little Demon",
    originalLanguage: "en",
    originalName: "Little Demon",
    overview: "13 years after being impregnated by Satan, a reluctant mother, Laura, and her Antichrist daughter, Chrissy, attempt to live an ordinary life in Delaware, but are constantly thwarted by monstrous forces, including Satan, who yearns for custody of his daughter's soul.",
    popularity: 10.956,
    posterPath: "/2lyFPOe6JScMBiLQuMtf3pPZxAu.jpg",
    voteAverage:  8.7,
    voteCount: 25
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
    backdropPath: "backdropPath",
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    name: "name",
    overview: "overview",
    popularity: 1,
    posterPath: "posterPath",
    seasons: [
      TvSeason(
          id: 1,
          posterPath: "posterPath")
    ],
    voteAverage: 1,
    voteCount: 1);

final testWatchlistTv = Tv.watchList(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'name': 'name',
  'posterPath': 'posterPath',
  'overview': 'overview',
};
