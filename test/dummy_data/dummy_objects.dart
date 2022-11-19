import 'package:ditonton/data/movie/models/movie_table.dart';
import 'package:ditonton/data/tv/model/tv_table.dart';
import 'package:ditonton/domain/movie/entities/genre.dart';
import 'package:ditonton/domain/movie/entities/movie.dart';
import 'package:ditonton/domain/movie/entities/movie_detail.dart';
import 'package:ditonton/domain/tv/entities/tv.dart';
import 'package:ditonton/domain/tv/entities/tv_detail.dart';
import 'package:ditonton/domain/tv/entities/tv_season.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
  'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

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
    episodeRunTime: [2],
    firstAirDate: "firstAirDate",
    genres: [Genre(id: 1, name: 'Action')],
    homepage: "homepage",
    id: 1,
    name: "name",
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    originalLanguage: "us",
    originalName: "originalName",
    overview: "overview",
    popularity: 1,
    posterPath: "posterPath",
    seasons: [
      TvSeason(airDate: "airDate",
          episodeCount: 1,
          id: 1,
          name: "name",
          overview: "overview",
          posterPath: "posterPath",
          seasonNumber: 1)
    ],
    status: "status",
    tagline: "tagline",
    type: "type",
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
  'title': 'title',
};
