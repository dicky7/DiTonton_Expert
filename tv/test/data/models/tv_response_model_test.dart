import 'dart:convert';

import 'package:ditonton/data/tv/model/tv_model.dart';
import 'package:ditonton/data/tv/model/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main(){
  final tvModel = TvModel(
      backdropPath: "/path.jpg",
      firstAirDate: "2006-09-18",
      genreIds: [1, 3, 4],
      id: 1,
      name: "name",
      originalLanguage: "originalLanguage",
      originalName: "originalName",
      overview: "overview",
      popularity: 1,
      posterPath: "/path.jpg",
      voteAverage: 1,
      voteCount: 1
  );

  final tvResponseModel = TvResponse(tvList: <TvModel>[tvModel]);
  group("from json", () {
    test('should return a valid model from JSON', () async{
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(readJson("dummy_data/on_the_air.json"));
      //act
      final result = TvResponse.fromJson(jsonMap);
      //assert
      expect(result, tvResponseModel);
    });
  });

  group("toJSon", () {
    test('should return a JSON map containing proper data', () async{
      //arrange

      //act
      final result = tvResponseModel.toJson();
      //assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "first_air_date": "2006-09-18",
            "genre_ids": [
              1,3,4
            ],
            "id": 1,
            "name": "name",
            "original_language": "originalLanguage",
            "original_name": "originalName",
            "overview": "overview",
            "popularity": 1,
            "poster_path": "/path.jpg",
            "vote_average": 1,
            "vote_count": 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}