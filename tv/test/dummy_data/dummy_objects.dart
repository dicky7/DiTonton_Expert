
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
      TvSeason(
          id: 1,
          posterPath: "posterPath")
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
  'overview': 'overview',
};
