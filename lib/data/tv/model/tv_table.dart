import 'package:equatable/equatable.dart';

import '../../../domain/tv/entities/tv.dart';
import '../../../domain/tv/entities/tv_detail.dart';

class TvTable extends Equatable {
  TvTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  factory TvTable.fromEntity(TvDetail tvShow) => TvTable(
    id: tvShow.id,
    name: tvShow.name,
    posterPath: tvShow.posterPath,
    overview: tvShow.overview,
  );

  factory TvTable.fromMap(Map<String, dynamic> map) => TvTable(
    id: map["id"],
    name: map["name"],
    posterPath: map["posterPath"],
    overview: map["overview"],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'posterPath': posterPath,
    'overview': overview,
  };

  Tv toEntity() => Tv.watchList(
    id: this.id,
    overview: this.overview,
    posterPath: this.posterPath,
    name: this.name,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    posterPath,
    overview,
  ];
}