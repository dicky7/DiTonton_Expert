
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/model/tv_model.dart';
import 'package:tv/domain/entities/tv.dart';

void main() {
  final tvModel = TvModel(
      backdropPath: "backdropPath",
      firstAirDate: "firstAirDate",
      genreIds: [1, 3, 4],
      id: 1,
      name: "name",
      originalLanguage: "originalLanguage",
      originalName: "originalName",
      overview: "overview",
      popularity: 1,
      posterPath: "posterPath",
      voteAverage: 1,
      voteCount: 1
  );

  final tvEntity = Tv(
      backdropPath: "backdropPath",
      firstAirDate: "firstAirDate",
      genreIds: [1, 3, 4],
      id: 1,
      name: "name",
      originalLanguage: "originalLanguage",
      originalName: "originalName",
      overview: "overview",
      popularity: 1,
      posterPath: "posterPath",
      voteAverage: 1,
      voteCount: 1
  );

  test('should be a subclass of Tv entity', () async {
    final result = tvModel.toEntity();
    expect(result, tvEntity);
  });
}