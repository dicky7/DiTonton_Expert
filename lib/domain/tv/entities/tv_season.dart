import 'package:equatable/equatable.dart';

class TvSeason extends Equatable {
  TvSeason({
    required this.id,
    required this.posterPath,
  });

  final int id;
  final String? posterPath;

  @override
  // TODO: implement props
  List<Object?> get props => [
        this.id,
        this.posterPath,
      ];
}
