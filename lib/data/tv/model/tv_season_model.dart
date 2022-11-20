import 'package:equatable/equatable.dart';

import '../../../domain/tv/entities/tv_season.dart';

class TvSeasonModel extends Equatable {
  TvSeasonModel({
    required this.id,
    required this.posterPath,
  });

  final int id;
  final String? posterPath;

  factory TvSeasonModel.fromJson(Map<String, dynamic> json) => TvSeasonModel(
        id: json["id"],
        posterPath: json["poster_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "poster_path": posterPath,
      };

  TvSeason toEntity() {
    return TvSeason(
        id: this.id,
        posterPath: this.posterPath,);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        this.id,
        this.posterPath,
      ];
}
