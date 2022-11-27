
import 'package:core/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv_season.dart';


class TvDetail extends Equatable{
  TvDetail({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.name,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.seasons,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String name;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<TvSeason> seasons;
  final double voteAverage;
  final int voteCount;

  @override
  // TODO: implement props
  List<Object?> get props => [
    backdropPath,
    genres,
    id,
    name,
    overview,
    popularity,
    posterPath,
    seasons,
    voteAverage,
    voteCount,
  ];

}