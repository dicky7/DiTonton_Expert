import 'package:equatable/equatable.dart';

class TvSeason extends Equatable {
  TvSeason({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  final String? airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;

  @override
  // TODO: implement props
  List<Object?> get props => [
        this.airDate,
        this.episodeCount,
        this.id,
        this.name,
        this.overview,
        this.posterPath,
        this.seasonNumber
      ];
}
